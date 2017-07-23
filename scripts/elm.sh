elm_setup() {
  helper_dontfail which elm

  if [ $? -ne 0 ]; then
    sudo npm install -g elm
  fi
}
