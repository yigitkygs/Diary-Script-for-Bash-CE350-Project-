#!/bin/bash


dialog --menu "Choose one" 10 30 2 1 "New Entry" 2 "Read Diary" 2>temp

 
# OK is pressed
if [ "$?" = "0" ]
then

	exec 3>&1
    choice=$(cat temp)
         # New Entry is pressed
        if [ "$choice" = "1" ]
        then
	    name=$(dialog --inputbox "Enter the desired name for your new entry:" 10 30 2>&1 1>&3)
	    pass=$(tempfile 2>/dev/null)
	    trap "rm -f $pass" 0 1 2 5 15
	    dialog --title "Password" \
		   --clear \
		   --insecure \
		   --passwordbox "Enter the password for your new entry:" 10 30 2>$pass
	    echo  "\n"
            dialog --inputbox "Write about your day" 250 250 2>$name
	    zip --password $(cat $pass) diary.zip $name
	    rm -f name
        fi

	# Read Diary is pressed
        if [ "$choice" = "2" ]
        then
            dialog --title "Older Entries" --msgbox "$(unzip -l diary.zip )" 100 100
	    exec 3>&1
	    D=$(dialog --inputbox "Enter the desired entry name" 10 30 2>&1 1>&3)
	    dialog --title "Your entry" --msgbox "$(unzip -p diary.zip $D )" 100 100    
        fi
 
 
# Cancel is pressed
else
        echo "Exiting"
fi

 
# remove the temp file
rm -f temp
