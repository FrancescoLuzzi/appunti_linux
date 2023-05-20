#!/bin/bash

function show_help(){
  cat <<EOF
Usage:
user_generator.sh: -f [filename]

-f        specify filename to be used
-f-       get input from stdin
EOF
}

file=""
while getopts ":f" OPTION; do
  case "$OPTION" in
  f)
    file="$OPTARG"
    ;;
  "?")
    file="/dev/stdin"
    ;;
  *)
    echo "opzione -$OPTION non riconosciuta"
    # show_help
    exit 1
    ;;
  esac
done

shift "$((OPTIND - 1))"

if [ "$file" = "" ]; then
  echo "errore file"
  exit 1
fi

(
  while IFS=$'\n,'EOF read -t 1 user_name new_shell; do
    # useradd $user_name -s $new_shell
    if [ -z "$user_name" -o -z "$new_shell"];then
      echo username or shell is empty
      continue
    fi
    echo "changing user $user_name's shell to $new_shell"
    chsh --shell "$new_shell" "$user_name"
  done
) <$file
