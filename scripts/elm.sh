elm_setup() {
  helper_dontfail which elm > /dev/null

  if [ $? -ne 0 ]; then
    helper_sudo npm install -g elm
  fi
}
