helper_dontfail() {
  echo $- | grep e > /dev/null

  local ERR_STATUS=$?

  if [ ${ERR_STATUS} -eq 0 ]; then
    set +e
  fi

  "$@"

  if [ ${ERR_STATUS} -eq 0 ]; then
    set -e
  fi
}

source "${CONFIG_DIR}/scripts/apt.sh"
source "${CONFIG_DIR}/scripts/git.sh"
source "${CONFIG_DIR}/scripts/shell.sh"

apt_setup
git_configure
shell_setup
