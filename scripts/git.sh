git_maybe_configure() {
  git config --global "${1}" > /dev/null || git config --global "${1}" "${2}"
}

git_setup() {
  git_maybe_configure user.name 'Patrick Pokatilo'
  git_maybe_configure user.email 'mail@shyxormz.net'
  git_maybe_configure alias.graph 'log --all --decorate --graph'
  git_maybe_configure alias.pushor '!sh -c "git push -u origin $(git rev-parse --abbrev-ref HEAD)"'
  git_maybe_configure core.editor 'vim'
  git_maybe_configure core.excludesfile "${HOME}/.gitignore_global"

  if [ ! -f "${HOME}/.gitignore_global" ]; then
    echo '/.idea/' > "${HOME}/.gitignore_global"
  fi
}
