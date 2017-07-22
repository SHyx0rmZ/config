git_maybe_configure() {
  git config --global "${1}" > /dev/null || git config --global "${1}" "${2}"
}

git_configure() {
  git_maybe_configure user.name 'Patrick Pokatilo'
  git_maybe_configure user.email 'mail@shyxormz.net'
  git_maybe_configure alias.graph 'log --all --decorate --graph'
}