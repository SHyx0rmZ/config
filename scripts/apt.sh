apt_maybe_install() {
  dpkg-query -s "${1}" > /dev/null 2>&1

  if [ $? -ne 0 ]; then
    helper_sudo apt install "${1}"
  fi
}

apt_maybe_install_direnv() {
  helper_dontfail apt_maybe_install direnv

  if [ -d /etc/bashrc.d ]; then
    if [ ! -f /etc/bashrc.d/direnv.sh ]; then
      helper_sudo cp "${CONFIG_DIR}/files/direnv.sh" /etc/bashrc.d/direnv.sh
    fi

    source /etc/bashrc.d/direnv.sh
  fi
}

apt_maybe_install_gpu_firmware() {
  lspci | grep -E 'VGA\b.*\bAMD\b.*\bRadeon\b' > /dev/null

  if [ $? -eq 0 ]; then
    apt_maybe_install firmware-amd-graphics
  fi
}

apt_maybe_install_terminator() {
  helper_dontfail apt_maybe_install python3-configobj
  helper_dontfail apt_maybe_install terminator

  gsettings set org.mate.applications-terminal exec terminator
  python3 "${CONFIG_DIR}/files/terminator-config.py"
}

apt_setup() {
  for package in \
    build-essential \
    dfc \
    curl \
    git \
    htop \
    iftop \
    iotop \
    jq \
    libavcodec-extra \
    ltrace \
    strace \
    vlc \
    vim \
  ; do
    helper_dontfail apt_maybe_install "${package}"
  done

  helper_dontfail apt_maybe_install_gpu_firmware

  apt_maybe_install_direnv
  apt_maybe_install_terminator
}
