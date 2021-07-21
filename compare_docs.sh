#!/bin/bash

usage="$(basename "$0") [-o <filename.docx>] [-n filename.docx] -- script to compare [o]ld and [n]ew revisions of docx documentation

where:
    -o  path to file with old version
    -n  path to file with old version"

while getopts ':h:n:o:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    o) old_ver_docx_path=$OPTARG
       ;;
    n) new_ver_docx_path=$OPTARG
       ;;
  esac
done

if [ -z "$old_ver_docx_path" ] || [ -z "$new_ver_docx_path" ]
then
   echo "Some or all of the parameters are empty";
   echo "$usage"
   exit
fi

while true; do
    read -p "Do you wish to install pandoc (sudo apt install pandoc)? [Y/n] " yn
    case $yn in
        [Yy]* ) sudo apt install pandoc; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Do you wish to install pandoc (sudo apt install meld)? [Y/n] " yn
    case $yn in
        [Yy]* ) sudo apt install meld; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "Converting $old_ver_docx_path and $new_ver_docx_path to .md"

old_ver_md_path=$old_ver_docx_path.md
new_ver_md_path=$new_ver_docx_path.md

pandoc -f docx -t markdown -o $old_ver_md_path $old_ver_docx_path
pandoc -f docx -t markdown -o $new_ver_md_path $new_ver_docx_path

echo "Converted $old_ver_docx_path to $old_ver_md_path"
echo "Converted $new_ver_docx_path to $new_ver_md_path"

meld $old_ver_md_path $new_ver_md_path
