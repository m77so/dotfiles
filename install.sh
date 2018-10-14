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
  brew install coreutils fish zsh peco 
}

install_linux() {
  if [[ `uname -r` =~ ARCH$ ]]; then
    sudo pacman -S --noconfirm bash fish zsh git vim peco tmux coreutils
  elif [[ `cat /etc/system-release` =~ ^Amazon ]]; then
    sudo yum -y install bash zsh git peco tmux
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

