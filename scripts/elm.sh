elm_package() {
  command -v elm > /dev/null

  if [ $? -ne 0 ]; then
    helper_sudo npm install -g elm
  fi
}

elm_setup() {
  helper_dontfail elm_package
}
