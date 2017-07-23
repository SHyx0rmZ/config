go_cache_valid() {
  sha256sum --check --status "${CONFIG_DIR}/cache/go.sha256"
}

go_cache_update() {
  wget -qO- https://storage.googleapis.com/golang/ > "${CONFIG_DIR}/cache/go"

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
  cat "${CONFIG_DIR}/cache/go" | grep -oPm1 "(?<=<Key>)[^<]+\.linux-amd64\.[^<]+" | grep -v sha256 | sed 's/^\(go[0-9]\+\.[0-9]\+\)\(\.linux\)/\1.0xyz\2/' | sort -V | sed 's/\.0xyz//' | tail -n 1
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

    sudo rm -r /usr/local/go
  fi

  echo -e "  - \033[32minstalling\033[0m Go $(echo $(go_newest_version) | cut -f1 -dl | cut -f2 -do | sed 's/\.$//')"

  sudo tar -C /usr/local -xzf "${CONFIG_DIR}/cache/go.tar.gz"

  rm "${CONFIG_DIR}/cache/go.tar.gz"
  rm "${CONFIG_DIR}/cache/go.tar.gz.sha256"
}

go_env_setup() {
  if [ ! -d "${HOME}/work/go" ]; then 
    mkdir -p "${HOME}/work/go"
  fi

  if [ -d /etc/bashrc.d ]; then
    if [ ! -f /etc/bashrc.d/golang.sh ]; then
      sudo cp "${CONFIG_DIR}/files/golang.sh" /etc/bashrc.d/golang.sh

      source /etc/bashrc.d/golang.sh
    fi
  fi
}

go_setup() {
  if go_update_available; then
    go_update
  fi

  go_env_setup
}
