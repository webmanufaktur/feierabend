#!/bin/bash

clear

DATE=$(date  +%Y-%m-%d)
DRY_RUN=false

# Check for the "dry run" option
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    echo "🚨🚨 DRY RUN MODE ENABLED 🚨🚨"
    echo ""
fi

archive_files() {
    DIR=$1
    DIR_NAME=$2
    ARCHIVE=~/Documents/${DIR_NAME}-archive-$DATE
    FILE_COUNT=$(find $DIR -maxdepth 1 -type f | wc -l)

    echo ""
    echo "🗃️  Archiving: $DIR_NAME..."

    if [[ $FILE_COUNT -gt 0 ]] ; then
        echo "We have $FILE_COUNT $DIR_NAME files to archive."
        
        if $DRY_RUN; then
            echo "[DRY RUN] Would create directory: $ARCHIVE"
            echo "[DRY RUN] Would move files from $DIR to $ARCHIVE"
        else
            mkdir -p $ARCHIVE
            echo "Moving all $DIR_NAME files to archive now."
            find $DIR -maxdepth 1 -type f >> $ARCHIVE/$DATE-archived-files.txt
            mv $DIR* $ARCHIVE
        fi
    else
        echo "No files to archive."
    fi
}

echo "----------------------------------"
echo "Starting ⏲️  FEIERABEND protocol"
echo "----------------------------------"

# Add your folders here
archive_files ~/Downloads/ "downloads"
archive_files ~/Screenshots/ "screenshots"
archive_files ~/Desktop/ "desktop"

# Shutdown, reboot, go on
echo ""
read -p "Shutdown, Reboot or Continue? [Y/r/n]: " action_choice
action_choice=${action_choice:-Y}

case $action_choice in
    [Yy]* )
        echo "Shutting down..."
        systemctl poweroff
        ;;
    [Rr]* )
        echo "Rebooting..."
        systemctl reboot
        ;;
    [Nn]* )
        echo "Script completed. Continuing without action."
        ;;
    * ) 
        echo "Invalid choice. Exiting."
        ;;
esac
