#!/bin/bash

dir="/run/media/itsolegdm/file-trashbin/itsolegdm/jellyfin"

# Handle all new files
inotifywait -m -r -e create --format '%w%f' "$dir" | while read -r new_file
do
  case "$new_file" in
    *.nfo)
      filename=$(basename "$new_file")
      base="${filename%.*}"
      
      title=$(xmlstarlet sel -t -v "/movie/title" "$new_file"  | sed 's/_/ /g')
      if [ "$title" != "$base" ]; then
        xmlstarlet ed -u "/movie/title" -v "$base" "$new_file" > temp.xml && mv temp.xml "$new_file"
      fi
      ;;
  esac
done
