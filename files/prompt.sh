if [ -n "${BASH_VERSION}" -a -n "${PS1}" ]; then
  export PS1="\[$(tput bold)\]\[$(tput setaf 4)\]\h\[$(tput setaf 7)\]::\[$(tput setaf 1)\]\u\[$(tput setaf 7)\](\[$(tput setaf 3)\]\t\[$(tput setaf 7)\], \[$(tput setaf 2)\]\W\[$(tput setaf 7)\]) \\$ \[$(tput sgr0)\]"
fi
