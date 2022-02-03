#!/bin/bash

install -D -m755 qjackctl $HOME/.local/bin/
install -D -m755 start_qjackctl.sh $HOME/.local/

sudo apt-get install -y pulseaudio-module-jack qjackctl jack-rack

