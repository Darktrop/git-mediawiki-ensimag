#!/bin/sh

# This script installs or deletes a MediaWiki on your computer.
# It requires a web server with PHP and a database running and mediawiki installed.
# As it changes some permissions file, it surely needs root privileges.
# Please set the CONFIGURATION VARIABLES section below first.

#
# CONFIGURATION VARIABLES
#
WIKI_DIR_NAME="wiki"                    # Name of the wiki's directory
WIKI_DIR_INST="/var/www"                # Directory of the web server
WIKI_INST_DIR="/var/lib/mediawiki/"     # Directory of mediawiki installation
DB_NAME="wikidb"        # Name of the database
DB_SU_LOGIN="root"      # Login of the superuser in the database
DB_SU_PASSW="root"      # Password of the superuser in the database

#
# Function cmd_install()
# Install a wiki in your web server directory.
#
cmd_install()
{
        # Copy the files of a wiki in the web server's directory.
        # If LocalSettings.php exists, we should delete it so that the user
        # we will asked to enter the configuration settings later.
        cp -R "$WIKI_INST_DIR" "$WIKI_DIR_INST/$WIKI_DIR_NAME"
        if [ -f "$WIKI_DIR_INST/$WIKI_DIR_NAME/LocalSettings.php" ]; then
                rm "$WIKI_DIR_INST/$WIKI_DIR_NAME/LocalSettings.php"
        fi
        chmod -R ugo+rw "$WIKI_DIR_INST/$WIKI_DIR_NAME"
        chmod +x "$WIKI_DIR_INST/$WIKI_DIR_NAME/config/"

        # Ask the user to enter the configuration settings file until
        # this one is in the wiki's directory
        is_not_set=1
        while [ "$is_not_set" -eq "1" ] ; do
                read -p "Please, open http://localhost/$WIKI_DIR_NAME/config/index.php and set your configuration then send the form. Prompt any key when the form has been sent." yn

                # The user might have already moved the wiki configuration settings
                # file in the wiki's folder. If not we must do it.
                if [ -f "$WIKI_DIR_INST/$WIKI_DIR_NAME/LocalSettings.php" ] ; then
                        is_not_set=0
                else
                        # The configuration settings file is not in the wiki folder. If the WikiMedia's form
                        # has created it in config/ folder, we move it in wiki's directory. Otherwise, we
                        # need to wait because the user prompt a key by mistake.
                        if [ -f "$WIKI_DIR_INST/$WIKI_DIR_NAME/config/LocalSettings.php" ] ; then
                                cp "$WIKI_DIR_INST/$WIKI_DIR_NAME/config/LocalSettings.php" "$WIKI_DIR_INST/$WIKI_DIR_NAME"
                                is_not_set=0
                        else
                                echo "$WIKI_DIR_INST/$WIKI_DIR_NAME/config/LocalSettings.php does not exist. You should wait that the form is sent."
                        fi
                fi
        done

        echo "Your wiki has been installed. You can check it at http://localhost/$WIKI_DIR_NAME"
}

#
# Function cmd_clear()
# Delete the wiki created in the web server's directory and all its content
# saved in the database.
#
cmd_clear() {
        # Delete the wiki's directory
        rm -rf "$WIKI_DIR_INST/$WIKI_DIR_NAME"

        # Delete the database of the wiki
        if [ -f ".tmp" ] ; then
                echo "`pwd`/.tmp file exists, please delete it and launch the script again"
                exit 1
        fi
        echo "DROP DATABASE $DB_NAME ;" > .tmp
        mysql --user="$DB_SU_LOGIN" --password="$DB_SU_PASSW" "$DB_NAME" < .tmp
        rm .tmp
}

cmd_help() {
        echo "Usage: "
        echo "  ./install_wiki <install|delete|help>"
        echo "          install: Install a wiki on your computer."
        echo "          delete: Delete the wiki installation."
}

# Argument: install, delete
if [ "$1" = "install" ] ; then
        cmd_install
        exit 0
elif [ "$1" = "delete" ] ; then
        cmd_clear
        exit 0
else
        cmd_help
fi
