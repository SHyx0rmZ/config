shell_configure_prompt() {
  if [ ! -f /etc/bashrc.d/prompt.sh ]; then
    sudo cp "${CONFIG_DIR}/files/prompt.sh" /etc/bashrc.d/prompt.sh
  fi
}

shell_configure_rc_d() {
  if [ ! -f /etc/bash.bashrc ]; then
    echo -e "\033[31mUnknown bashrc\033[0m"
    exit 1
  fi

  grep '/etc/bashrc.d' /etc/bash.bashrc > /dev/null

  if [ $? -ne 0 ]; then
    sudo bash -c "cat \"${CONFIG_DIR}/files/bashrcd.sh\" >> /etc/bash.bashrc"
  fi

  if [ ! -f "${HOME}/.bashrc" ]; then
    echo -e "\033[31mUnknown .bashrc\033[0m"
    exit 1
  fi

  grep '/etc/bashrc.d' "${HOME}/.bashrc" > /dev/null

  if [ $? -ne 0 ]; then
    bash -c "cat \"${CONFIG_DIR}/files/bashrcd.sh\" >> ${HOME}/.bashrc"
  fi

  if [ ! -d /etc/bashrc.d ]; then
    sudo mkdir -p /etc/bashrc.d
  fi
}

shell_setup() {
  helper_dontfail shell_configure_rc_d
  helper_dontfail shell_configure_prompt
}
