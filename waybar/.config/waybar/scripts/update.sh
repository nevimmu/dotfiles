#! /bin/bash

while true; do
  nb_updates=$(checkupdates | wc -l)
  if [ ! "$nb_updates" = "0" ]; then
    echo " $nb_updates"
  else
    echo "Nothing"
  fi
  sleep 60
done