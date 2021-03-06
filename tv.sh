#!/bin/bash

PLAYER="mpv"

TITLES=(
  "RTP 1"
  "RTP 2"
  "SIC"
  "TVI"
  "RTP 3"
  "SIC Noticias"
  "TVI24"
  "RTP Memoria"
  "RTP Internacional"
  "RTP Madeira"
  "RTP Acores"
  "RTP Africa"
  "SIC Radical"
  "SIC Caras"
  "SIC K"
  "ARTV"
  "Porto Canal"
  "Euronews"
  "Kuriakos TV"
)

STREAMS=(
  "https://streaming-live.rtp.pt/liverepeater/smil:rtp1.smil/playlist.m3u8"
  "https://streaming-live.rtp.pt/liverepeater/smil:rtp2.smil/playlist.m3u8"
  "http://live.impresa.pt/live/sic/sic.m3u8"
  "__tvi"
  "https://streaming-live.rtp.pt/livetvhlsDVR/rtpndvr.smil/playlist.m3u8"
  "http://live.impresa.pt/live/sicnot/sicnot.m3u8"
  "__tvi24"
  "https://streaming-live.rtp.pt/liverepeater/smil:rtpmem.smil/playlist.m3u8"
  "https://streaming-live.rtp.pt/liverepeater/smil:rtpi.smil/playlist.m3u8"
  "https://streaming-live.rtp.pt/liverepeater/smil:rtpmadeira.smil/playlist.m3u8"
  "https://streaming-live.rtp.pt/liverepeater/smil:rtpacores.smil/playlist.m3u8"
  "https://streaming-live.rtp.pt/liverepeater/smil:rtpafrica.smil/playlist.m3u8"
  "http://live.impresa.pt/live/sicrad/sicrad.m3u8"
  "http://live.impresa.pt/live/siccaras/siccaras.m3u8"
  "http://live.impresa.pt/live/sick/sick.m3u8"
  "http://193.126.16.68:1935/livenlin4/mp4:2liveplncleanpub/playlist.m3u8"
  "--referrer='http://sapo.pt/' https://streamer-b02.videos.sapo.pt/live/portocanal/playlist.m3u8"
  "__euronews"
  "http://195.22.11.11:1935/ktv/ktv2/playlist.m3u8"
)

# dynamic streams
__tvi() { echo "https://video-auth6.iol.pt/live_tvi/live_tvi/playlist.m3u8?wmsAuthSign=$(wget https://services.iol.pt/matrix?userId= -o /dev/null -O -)"; }
__tvi24() { echo "https://video-auth6.iol.pt/live_tvi24/live_tvi24/playlist.m3u8?wmsAuthSign=$(wget https://services.iol.pt/matrix?userId= -o /dev/null -O -)"; }
__euronews() { echo $(wget http:$(wget http://pt.euronews.com/api/watchlive.json -O - -o /dev/null | cut -d\" -f4 | sed 's/\\//g') -O - -o /dev/null | cut -d\" -f12 | sed 's/\\//g'); }

# check if dependencies exist
type $PLAYER &>/dev/null || { echo "$PLAYER is not installed"; exit 1; }

PS3="Which TV channel do you want to watch? "
select choice in "${TITLES[@]}";
do
  if [[ -n $choice ]]; then
    for i in ${!TITLES[@]}
    do
      if [ "${TITLES[i]}" = "$choice" ]; then
        # check if dynamic stream
        if [ "${STREAMS[i]:0:2}" = "__" ]; then
          $PLAYER $(${STREAMS[i]})
        else
          $PLAYER ${STREAMS[i]}
        fi
        break
      fi
    done
  else
    echo "Invalid selection."
  fi
done
