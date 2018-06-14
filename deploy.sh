#!/bin/bash
DOT_DIRECTORY="${HOME}/dotfiles"
DOT_TARBALL="https://github.com/m77so/dotfiles/tarball/master"
REMOTE_URL="git@github.com:m77so/dotfiles.git"

# DOWNLOAD
if [ ! -d ${DOT_DIRECTORY} ]; then
  echo "Downloading dotfiles..."
  mkdir ${DOT_DIRECTORY}
  if has "git"; then
    git clone --recursive "${REMOTE_URL}" "${DOT_DIRECTORY}"
  else
    curl -fsSLo ${HOME}/dotfiles.tar.gz ${DOT_TARBALL}
    tar -zxf ${HOME}/dotfiles.tar.gz --strip-components 1 -C ${DOT_DIRECTORY}
    rm -f ${HOME}/dotfiles.tar.gz
  fi
  echo $(tput setaf 2)Download dotfiles complete!. ✔︎$(tput sgr0)
fi

# DEPLOY

cd ${DOT_DIRECTORY}

for f in .??*
do
  [[ ${f} = ".git" ]] && continue
  [[ ${f} = ".gitignore" ]] && continue
  [[ ${f} = ".config" ]]&& continue
  ln -snfv ${DOT_DIRECTORY}/${f} ${HOME}/${f}
done
cd ${DOT_DIRECTORY}/.config
for f in `\find . -maxdepth 8 -type f`
do
  ln -snfv ${DOT_DIRECTORY}/.config/${f:2} ${HOME}/.config/${f:2}
done
echo $(tput setaf 2)Deploy dotfiles complete!. ✔︎$(tput sgr0)


