#!/bin/bash
rm -r ~/.local/share/radiotray/*
sleep2
rsync -a /$HOME/.backup/radiotray/* /$HOME/.local/share/radiotray/
sleep2
killall radiotray && radiotray &
