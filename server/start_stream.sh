#!/bin/bash

export v_source=/Users/sfusco/fusco-macbook-livestream-localhost.sdp
export v_path=/Users/sfusco/Sites/video/
export v_livestream=http://10.0.1.2/~sfusco/video

rm -rf $v_path*
cvlc $v_source --sout='#transcode{threads=4,vcodec=h264,venc=x264{aud,profile=baseline,level=30, keyint=30,bframes=0,ref=1,nocabac},audio-sync}:standard{mux=ts,dst=-,access=file}' | mediastreamsegmenter -O -b $v_livestream -f $v_path -D
#cvlc $v_source --sout='#transcode{fps=25,vcodec=h264,venc=x264{aud,profile=baseline,level=30, keyint=30,bframes=0,ref=1,nocabac},acodec=mp3,ab=56,audio-sync,deinterlace}:standard{mux=ts,dst=-,access=file}' | mediastreamsegmenter -O -b $v_livestream -f $v_path -D
#/Applications/VLC.app/Contents/MacOS/VLC -vvvv $v_source --sout='#transcode{fps=25,vcodec=h264,venc=x264{aud,profile=baseline,level=30, keyint=30,bframes=0,ref=1,nocabac},acodec=mp3,ab=56,audio-sync,deinterlace}:standard{mux=ts,dst=-,access=file}' | mediastreamsegmenter -O -b $v_livestream -f $v_path -D
#/Applications/VLC.app/Contents/MacOS/VLC $v_source --sout='#transcode{fps=25,vcodec=h264,venc=x264}:standard{mux=ts,dst=-,access=file}' | mediastreamsegmenter -O -b $v_livestream -f $v_path -D
#/Applications/VLC.app/Contents/MacOS/VLC $v_source --sout='#standard{mux=ts,dst=-,access=file}' | mediastreamsegmenter -O -b $v_livestream -f $v_path -D

