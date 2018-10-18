apt_maybe_add_non_free() {
  if ! grep -P '^deb(-src)?\s.*\s(non-free)(\s.*|$)' /etc/apt/sources.list > /dev/null; then
    helper_sudo sed 's/^deb\(-src\)\?\s.*/\0 non-free/' -i /etc/apt/sources.list
    helper_sudo apt update
  fi
}

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
    apt_maybe_install amdgpu
    apt_maybe_install vulkan-amdgpu-pro
    apt_maybe_add_non_free
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
    apt-transport-https \
    build-essential \
    dfc \
    curl \
    dnsutils \
    fcitx-mozc \
    fonts-mplus \
    git \
    htop \
    iftop \
    iotop \
    jq \
    libavcodec-extra \
    ltrace \
    lynx \
    net-tools \
    strace \
    tree \
    vlc \
    vim \
  ; do
    helper_dontfail apt_maybe_install "${package}"
  done

  helper_dontfail apt_maybe_install_gpu_firmware

  apt_maybe_install_direnv
  apt_maybe_install_terminator
}
