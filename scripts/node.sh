node_setup() {
  if [ ! -f /etc/apt/sources.list.d/nodesource.list ]; then
    curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | helper_sudo apt-key add -
    helper_sudo bash -c "echo 'deb https://deb.nodesource.com/node_6.x stretch main' > /etc/apt/sources.list.d/nodesource.list"
    helper_sudo bash -c "echo 'deb-src https://deb.nodesource.com/node_6.x stretch main' >> /etc/apt/sources.list.d/nodesource.list"

    helper_sudo apt update
  fi

  helper_dontfail apt_maybe_install nodejs
}
