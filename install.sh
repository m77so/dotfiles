#! /bin/sh
has() {
  type "$1" > /dev/null 2>&1
}

if [ "$(uname)" == 'Darwin' ]; then
  OS='Mac'
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  OS='Linux'
elif [ "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]; then                                                                                           
  OS='Cygwin'
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi

# INITIALIZE
install_mac() {
  brew install coreutils fish zsh 
}

install_linux() {
  if [[ `uname -r` =~ ARCH$ ]]; then
    sudo pacman -S --noconfirm bash fish zsh jq git vim nodejs python-pip yarn tmux coreutils
  fi
}

if [[ $OS = 'Mac' ]]; then
  install_mac
elif [[ $OS = "Linux" ]]; then
  install_linux
fi
#zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh

pip install glances

# anyenv
git clone https://github.com/riywo/anyenv ~/.anyenv
