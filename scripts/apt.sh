apt_maybe_install() {
  dpkg-query -s "${1}" > /dev/null 2>&1

  if [ $? -ne 0 ]; then
    sudo apt install "${1}"
  fi
}

apt_maybe_install_gpu_firmware() {
  lspci | grep -E 'VGA\b.*\bAMD\b.*\bRadeon\b' > /dev/null

  if [ $? -eq 0 ]; then
    apt_maybe_install firmware-amd-graphics
  fi
}

apt_setup() {
  for package in \
    curl \
    git \
    htop \
    iftop \
    iotop \
    jq \
    libavcodec-extra \
    ltrace \
    strace \
    vim \
  ; do
    helper_dontfail apt_maybe_install "${package}"
  done

  helper_dontfail apt_maybe_install_gpu_firmware
}
