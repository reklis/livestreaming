#!/bin/bash

/Applications/VLC.app/Contents/MacOS/VLC fusco-macbook-livestream-localhost.sdp --sout='#standard{mux=ts,dst=-,access=file}' | ffmpeg -i pipe:0 -f mpegts -acodec libmp3lame -ar 48000 -ab 64k -vcodec libx264 -b 96k pipe:1 | cat | mediastreamsegmenter -O -b http://localhost/~sfusco/video -f /Users/sfusco/Sites/video/ -D