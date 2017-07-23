elm_setup() {
  helper_dontfail which elm > /dev/null

  if [ $? -ne 0 ]; then
    sudo npm install -g elm
  fi
}
