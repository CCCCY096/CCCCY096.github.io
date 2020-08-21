#!/bin/sh

set -e # stops when errors occur

typora_path="/mnt/c/Users/CCY/OneDrive/Notes/GitHub_Page/"
repo_path="/home/ccy/src/CCCCY096.github.io/"
op="$1"
help_message="help, to_typora, to_repo"

case "$op" in
    "help")
        echo $help_message;;
    "to_typora")
        echo "Copying markdown files from repo to typora..."
        cp -f "$repo_path"*.md "$typora_path"
        echo "Success!";;
    "to_repo")
        echo "Copying markdown files from typora to repo..."
        cp -f "$typora_path"*.md "$repo_path"
        echo "Success!"
        git status;;
    *)
        echo "Fuck off. Use help option.";;
esac