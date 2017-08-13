flash_setup() {
  if [ -d /usr/local/lib/adobe-flashplugin -a -d /etc/chromium.d ]; then
    if [ ! -f /etc/chromium.d/flash ]; then
      helper_sudo cp "${CONFIG_DIR}/files/chromium/flash" /etc/chromium.d/flash
    fi
  fi
}
