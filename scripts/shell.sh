shell_add_binary() {
  if [ ! -f "${HOME}/work/utils/bin/$(basename "$1")" ]; then
    cp "$1" "${HOME}/work/utils/bin/$(basename "$1")"
  fi
}

shell_add_binary_link() {
  if [ ! -h "${HOME}/work/utils/bin/$(basename "$1")" ]; then
    ln -s "$1" "${HOME}/work/utils/bin/$(basename "$1")"
  fi
}

shell_configure_composer_wrapper() {
  shell_add_binary_link "${CONFIG_DIR}/modules/sh-composer-wrapper/composer"
}

shell_configure_path() {
  if [ ! -d "${HOME}/work/utils/bin" ]; then
    mkdir -p "${HOME}/work/utils/bin"
  fi

  if [ ! -f /etc/bashrc.d/bin.sh ]; then
    helper_sudo cp "${CONFIG_DIR}/files/bin.sh" /etc/bashrc.d/bin.sh
  fi
}

shell_configure_prompt() {
  if [ ! -f /etc/bashrc.d/prompt.sh ]; then
    helper_sudo cp "${CONFIG_DIR}/files/prompt.sh" /etc/bashrc.d/prompt.sh
  fi
}

shell_configure_rc_d() {
  if [ ! -f /etc/bash.bashrc ]; then
    echo -e "\033[31mUnknown bashrc\033[0m"
    exit 1
  fi

  grep '/etc/bashrc.d' /etc/bash.bashrc > /dev/null

  if [ $? -ne 0 ]; then
    helper_sudo bash -c "cat \"${CONFIG_DIR}/files/bashrcd.sh\" >> /etc/bash.bashrc"
  fi

  if [ ! -f "${HOME}/.bashrc" ]; then
    echo -e "\033[31mUnknown .bashrc\033[0m"
    exit 1
  fi

  grep '/etc/bashrc.d' "${HOME}/.bashrc" > /dev/null

  if [ $? -ne 0 ]; then
    bash -c "cat \"${CONFIG_DIR}/files/bashrcd.sh\" >> ${HOME}/.bashrc"
  fi

  if [ ! -f "${HOME}/.profile" ]; then
    echo -e "\033[31mUnknown .profile\033[0m"
    exit 1
  fi

  grep '/etc/bashrc.d' "${HOME}/.profile" > /dev/null

  if [ $? -ne 0 ]; then
    bash -c "cat \"${CONFIG_DIR}/files/bashrcd.profile\" >> ${HOME}/.profile"
  fi

  if [ ! -d /etc/bashrc.d ]; then
    helper_sudo mkdir -p /etc/bashrc.d
  fi
}

shell_setup() {
  helper_dontfail shell_configure_rc_d
  helper_dontfail shell_configure_prompt
  helper_dontfail shell_configure_path

  shell_configure_composer_wrapper
}
