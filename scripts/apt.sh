apt_maybe_install() {
  echo $- | grep e > /dev/null

  local ERR_STATUS=$?

  if [ ${ERR_STATUS} -eq 0 ]; then
    set +e
  fi

  dpkg-query -l "${1}" > /dev/null 2>&1

  if [ $? -ne 0 ]; then
    sudo apt install "${1}"
  fi

  if [ ${ERR_STATUS} -eq 0 ]; then
    set -e
  fi
}

apt_setup() {
  for package in \
    git \
    htop \
    iftop \
    iotop \
    ltrace \
    strace \
    vim \
  ; do
    apt_maybe_install "${package}"
  done
}
