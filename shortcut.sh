#!/bin/bash

# shortcut.sh - Script to define a application shortcut
#
# How to use:
#
# ./shortcut.sh
#
# Infos:
#
# - All icons are created in ~/.local/share/applications
# - All fields must be filled
# - Version must be in the following format: X.Y (where X and Y are numbers)
# - Categories must be in the following format: C1;C2;C3

label=""
file_name=""
version=""
name=""
comment=""
type=""
categories=""
exec=""
icon=""
name=""
sections=$(echo "file_name version name comment type categories exec icon name")

input_is_valid() {
    local field=$1
    local value=$2

    case "$field" in
    version)
        if echo "$value" | egrep -sq "[0-9]+\.[0-9]+"; then
            return 0
        fi
        ;;
    categories)
        if echo "$value" | egrep -sq "([A-Z]|[a-z])+;+"; then
            return 0
        fi
        ;;
    *) if test -n "$value"; then
        return 0
    fi ;;
    esac

    return 1
}

read_input() {
    local value

    if test -z "$1" || test -z "$2"; then
        echo "Invalid params"
        exit 1
    fi

    IFS= read -r -p "$1" value
    input_is_valid $2 "$value"

    if test "$?" = "1"; then
        echo "Invalid value for $(echo $2 | tr "[:lower:]" "[:upper:]")"
        exit 1
    else
        value=$(echo "$value" | tr -d '$`')
        eval "$2=\"$value\""
    fi
}

for section in $sections; do
    label=$(echo "$section" | tr "[:lower:]" "[:upper:]")
    read_input "$label: " $section
done

echo "$file_name $version $name $comment $type $categories $exec $icon $name"

printf "[Desktop Entry]
Version=$version
Name=$name
Comment=$comment
Type=$type
Categories=$categories
Exec=$exec
Icon=$icon
Name[en_US]=$name
" >~/.local/share/applications/$file_name.desktop
