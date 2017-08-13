helper_dontfail() {
  echo $- | grep e > /dev/null

  local ERR_STATUS=$?

  if [ ${ERR_STATUS} -eq 0 ]; then
    set +e
  fi

  "$@"

  local EXIT_STATUS=$?

  if [ ${ERR_STATUS} -eq 0 ]; then
    set -e
  fi

  return ${EXIT_STATUS}
}

helper_sudo() {
  sudo -k -p "$(echo -e "Trying to execute: \033[36msudo $(echo "$@" | sed 's/%/%%/g')\033[0m\n[sudo] password for %p: ")" "$@"
}

setup() {
  echo -e "- setting up \033[32m${1}\033[0m"
  ${1}_setup
}

source "${CONFIG_DIR}/scripts/apt.sh"
source "${CONFIG_DIR}/scripts/elm.sh"
source "${CONFIG_DIR}/scripts/flash.sh"
source "${CONFIG_DIR}/scripts/git.sh"
source "${CONFIG_DIR}/scripts/go.sh"
source "${CONFIG_DIR}/scripts/node.sh"
source "${CONFIG_DIR}/scripts/shell.sh"
source "${CONFIG_DIR}/scripts/vim.sh"

setup shell
setup apt
setup git
setup vim
setup flash
setup go
setup node
setup elm
