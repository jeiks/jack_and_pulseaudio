#!/bin/bash

## Selecting the dialog:
if which kdialog;then
    DIALOG='kdialog --msgbox'
elif which zenity;then
    DIALOG='zenity --info --no-wrap --text'
else
    DIALOG='echo'
fi

## Starting jack-rack:
if ! pidof jack-rack;then
   jack-rack &
fi

## Checking if jack modules are loaded:
if ! pacmd list-sinks | grep -q module-jack-sink.c;then
    echo "Loading module-jack-sink..." >&2
    pactl load-module module-jack-sink
fi

if ! pacmd list-sources | grep -q module-jack-source.c;then
    echo "Loading module-jack-source" >&2
    pactl load-module module-jack-source
fi

## Selecting JACK SINK and JACK SOURCE:
JACK_SINK_INDEX=$(pacmd list-sinks | awk '{if ($2 == "index:") idx = $NF;if ($1 == "driver:" && $2 == "<module-jack-sink.c>") print idx}')
JACK_SOURCE_INDEX=$(pacmd list-sources | awk '{if ($2=="index:") idx=$NF; if ($1=="driver:" && $2=="<module-jack-source.c>") print idx}')

## Setting JACK SINK and JACK SOURCE:
if [ -n "$JACK_SINK_INDEX" ];then
    pacmd set-default-sink $JACK_SINK_INDEX
else
    echo "Error getting JACK SINK INDEX" >&2
fi

if [ -n "$JACK_SOURCE_INDEX" ];then
    pacmd set-default-source $JACK_SOURCE_INDEX
else
    echo "Error getting JACK SOURCE INDEX" >&2
fi

##Explaining how to configure the JACK Audio Connection Kit
$DIALOG "Connections:
PulseAudio JACK Sink  ===>  system

system->capture_1     ===>  jack_rack
OR:
system->capture_2     ===>  jack_rack

jack_rack->out_1      ===> PulseAudio JACK Source" &
