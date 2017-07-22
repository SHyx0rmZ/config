vim_setup() {
  if [ ! -f "${HOME}/.vimrc" ]; then
    cp "${CONFIG_DIR}/files/vim/vimrc" "${HOME}/.vimrc"
  fi
}
