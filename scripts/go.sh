go_cache_valid() {
  sha256sum --check --status "${CONFIG_DIR}/cache/go.sha256" 2> /dev/null
}

go_cache_update() {
  local TEMP_DIR="$(mktemp -d)"
  local SEQUENCE=0
  local NEXT_PAGE_TOKEN=""

  while [ "${NEXT_PAGE_TOKEN}" != "?pageToken=" ]; do
    wget -qO- "https://www.googleapis.com/storage/v1/b/golang/o${NEXT_PAGE_TOKEN}" > "${TEMP_DIR}/go.${SEQUENCE}"

    NEXT_PAGE_TOKEN="?pageToken=$(cat ${TEMP_DIR}/go.${SEQUENCE} | jq -r 'if has("nextPageToken") then .nextPageToken else empty end')"
    SEQUENCE=$((SEQUENCE+1))
  done

  cat "${TEMP_DIR}/go."* | jq -r '.items[] | select(.name | test("go.*linux-amd64"))' | jq -rs 'flatten' > "${CONFIG_DIR}/cache/go"

  rm -r "${TEMP_DIR}"

  if [ -f "${CONFIG_DIR}/cache/go" ]; then
    helper_dontfail go_cache_valid

    if [ $? -eq 0 ]; then
      return 1
    fi
  fi

  sha256sum "${CONFIG_DIR}/cache/go" > "${CONFIG_DIR}/cache/go.sha256"

  return 0
}

go_update_available() {
  go_cache_update

  local VERSION_NEWEST="$(echo $(go_newest_version) | cut -f1 -dl)"
  local VERSION_CURRENT="$(echo $(go_current_version) | cut -f3 -d' ')."

  test "${VERSION_NEWEST}" != "${VERSION_CURRENT}"
}

go_newest_version() {
  cat "${CONFIG_DIR}/cache/go" | jq -r '.[]|select(.name|test("^go\\d+(\\.\\d+)*.linux-amd64.tar.gz$"))|.name' | sed 's/^\(go[0-9]\+\.[0-9]\+\)\(\.linux\)/\1.0xyz\2/' | sort -V | sed 's/\.0xyz//' | tail -n 1
}

go_current_version() {
  if [ ! -x /usr/local/go/bin/go ]; then
    echo "-"
  else
    /usr/local/go/bin/go version
  fi
}

go_update() {
  local VERSION_NEWEST="$(go_newest_version)"

  wget --show-progress -qO "${CONFIG_DIR}/cache/go.tar.gz" "https://storage.googleapis.com/golang/${VERSION_NEWEST}" 
  wget -qO "${CONFIG_DIR}/cache/go.tar.gz.sha256" "https://storage.googleapis.com/golang/${VERSION_NEWEST}.sha256"

  echo "  ${CONFIG_DIR}/cache/go.tar.gz" >> "${CONFIG_DIR}/cache/go.tar.gz.sha256"

  sha256sum --check "${CONFIG_DIR}/cache/go.tar.gz.sha256"

  if [ -d /usr/local/go ]; then
    echo -e "  - \033[31mremoving\033[0m Go $(echo $(go_current_version) | cut -f3 -d' ' | cut -f2 -do)"

    helper_sudo rm -r /usr/local/go
  fi

  echo -e "  - \033[32minstalling\033[0m Go $(echo $(go_newest_version) | cut -f1 -dl | cut -f2 -do | sed 's/\.$//')"

  helper_sudo tar -C /usr/local -xzf "${CONFIG_DIR}/cache/go.tar.gz"

  rm "${CONFIG_DIR}/cache/go.tar.gz"
  rm "${CONFIG_DIR}/cache/go.tar.gz.sha256"
}

go_env_setup() {
  if [ ! -d "${HOME}/work/go" ]; then 
    mkdir -p "${HOME}/work/go"
  fi

  if [ -d /etc/bashrc.d ]; then
    if [ ! -f /etc/bashrc.d/golang.sh ]; then
      helper_sudo cp "${CONFIG_DIR}/files/golang.sh" /etc/bashrc.d/golang.sh
    fi

    if [ -z "${GOPATH}" ]; then
      source /etc/bashrc.d/golang.sh
    fi
  fi
}

go_install_packages() {
  go get github.com/Masterminds/glide
  go get github.com/onsi/ginkgo/ginkgo
}

go_setup() {
  if go_update_available; then
    go_update
  fi

  go_env_setup

  go_install_packages
}
