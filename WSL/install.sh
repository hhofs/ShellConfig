#!/bin/bash
HOME_DIR="$1"
if [ -z $HOME_DIR ]; then 
 HOME_DIR="~"
fi
SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
wget -q https://github.com/JanDeDobbeleer/oh-my-posh3/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
chmod +x /usr/local/bin/oh-my-posh

cp -f $SCRIPT_DIR/.zshrc $HOME_DIR
mkdir -p $HOME_DIR/.poshthemes
cp -f $SCRIPT_DIR/../henk.json $HOME_DIR/.poshthemes
