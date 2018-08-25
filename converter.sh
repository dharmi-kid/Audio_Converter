#!/bin/bash  

#This is a script to convert flac files to mp3

if [ ! -d "$(pwd)/converted" ]; then
      		mkdir -p $(pwd)/converted
      	fi
counter=0
convertfolder(){
	for i in "$1"/*;
	do		
		filename="${i##*/}" 
     dir="${i:0:${#i} - ${#filename}}"
     base="${filename%.[^.]*}"
     ext="${filename:${#base} + 1}"
     if [[ -z "$base" && -n "$ext" ]]; then          
        base=".$ext"
        ext="nil"
    fi    

    if     [ -f "$i" ]; then    
      if [ $ext == "flac" ]; then
      
      ffmpeg -i "$i" -ab 320k -map_metadata 0 -id3v2_version 3 "$(pwd)/converted/$base".mp3 
      counter=$((counter + 1))
  fi
		elif [ -d "$i" ]; then
			convertfolder "$i"
		fi
	done
}
data(){
	if [ "$data" -eq 0 ]; then
		input=$(zenity \
        	--file-selection \
        	--filename="Input.mp3" \
        	--title="Please select Input file"\
        	--directory )

        	if [ "$?" -eq 1 ]; then
        		zenity --error --text="No directory selected \n\n Aborting" --title="Error" >/dev/null 2>&1 
	        		exit 1
	        fi

        	convertfolder "$input"
        	return 0

        else

	input=$(zenity \
        	--file-selection \
        	--filename="Input.mp3" \
        	--title="Please select Input file"\
        	--file-filter="Audio | *.flac")
        fi

        	if [ "$?" -eq 1 ]; then
        		zenity --error --text="No directory selected \n\n Aborting" --title="Error" >/dev/null 2>&1 
	        		exit 1
	        fi

    output=$(zenity \
    			--file-selection \
    			--save \
    			--title="Select Save Directory" \
    			--filename="output.mp3" \
    			)
    			
    			if [ "$?" -eq 1 ]; then
    				zenity --error --text="User aborted the operation" --title="User Abort" >/dev/null 2>&1
    				exit 1
    			fi
}

zenity \
--info \
--text="<span foreground='teal' font='12'>Audio Converter V1.0.0</span>\n <span font='7'>Made by The Enterprise</span> \n \n Please press OK to continue" --width=350 >/dev/null 2>&1\

command -v ffmpeg >/tmp/check_ffmpeg
	read a</tmp/check_ffmpeg

        if [ "$a" ==  "" ]; then
            zenity --info --text="ffmpeg is not present and is required to continue the program" >/dev/null 2>&1
                exit 1
        else
        	zenity --question --text="File or Folder ?" --title="Question" --ok-label="File" --cancel-label="Folder"
        	if [ "$?" -eq 0 ]; then			
        	data
        	ffmpeg -i "$input" -ab 320k -map_metadata 0 -id3v2_version 3 "$output" 
        	rm -f /tmp/check_ffmpeg
        else
        	data=0
        	data
        	if [ "$counter" == 0 ]; then
        		zenity --error --text="No flac file found!" --title="Files not found"
        	else
        	(zenity \
        	--info \
        	--text="Conversion Done \n\n Files Converted: $counter" \
        	--title="Done" >/dev/null 2>&1) 
        fi
        	rm -f /tmp/check_ffmpeg
        	clear
    	fi
    	fi 
