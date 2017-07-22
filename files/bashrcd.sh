if [ -d /etc/bashrc.d ]; then
  for i in /etc/bashrc.d/*.sh; do
    if [ -r $i ]; then
      . $i
    fi
  done
  unset i
fi
