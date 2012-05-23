#!/bin/sh

# This script installs or deletes a Mediawiki on your computer.
# It requires a web server with PHP and a database running and mediawiki installed. As it changes some permissions file, it might need root privileges.
# Please set the CONFIGURATION VARIABLES section below first.

#
# CONFIGURATION VARIABLES
#
WIKI_DIR_NAME="wiki"                    # Name of the wiki's directory
WIKI_DIR_INST="/var/www"                # Directory of the web server
WIKI_INST_DIR="/var/lib/mediawiki/"     # Directory of mediawiki
DB_NAME="wikidb"        # Name of the database
DB_SU_LOGIN="root"      # Login of the superuser in the database
DB_SU_PASSW="root"      # Password of the superuser in the database

cmd_install()
{
        cp -R "$WIKI_INST_DIR" "$WIKI_DIR_INST/$WIKI_DIR_NAME"
        chmod -R ugo+rw "$WIKI_DIR_INST/$WIKI_DIR_NAME"
        chmod +x "$WIKI_DIR_INST/$WIKI_DIR_NAME/config/"

        is_not_set=1
        while [ "$is_not_set" -eq "1" ] ; do
                read -p "Please, open http://localhost/$WIKI_DIR_NAME/config/index.php and set your configuration then send the form. Prompt any key when the form has been sent." yn

                # The user might have already moved the WikiMedia's configuration
                # file in the right folder. If not we must do it.
                if [ -f "$WIKI_DIR_INST/$WIKI_DIR_NAME/LocalSettings.php" ] ; then
                        is_not_set=0
                else
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

# Verify that services are running
# TODO
cmd_verify() {
        # Apache with PHP
        # MySQL
        echo "Make sure your services (web server with PHP and database) are running"
}

cmd_help() {
        echo "Usage: "
        echo "  ./install_wiki <install|clear|help>"
        echo "          install: (TODO) Install a mediawiki on your computer."
        echo "          clear: Delete your mediawiki installation."
}

# Argument: install, clear, verify
if [ "$1" = "install" ] ; then
        cmd_verify
        cmd_install
        exit 0
elif [ "$1" = "clear" ] ; then
        cmd_verify
        cmd_clear
        exit 0
else
        cmd_help
fi
