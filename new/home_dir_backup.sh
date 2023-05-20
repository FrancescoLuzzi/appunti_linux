#!/bin/bash

helper(){
  cat <<EOF
Usage:
home_dir_backup.sh: user@[ip|hostname] remote_dir

ip|hostname           Username e macchina remota su cui salvare i backup della home
remote_dir            Directory sulla cartella remota su cui salvare il backup
EOF
  
}

if [ $# -ne 2 ];then
  echo "parametri mancanti"
  helper
  exit 1
fi

machine=$1
remote_dir=$2

if [[ ! $remote_dir =~ .+/$ ]];then
  # controllo e forzo che sia una directory
  remote_dir="$remote_dir/"
fi

tar_filename="home_backup_$(date +%Y_%m_%d-%H:%M).tar.gz"

if [ ! -d /var/backup ];then
  mkdir /var/backup
fi

echo "Inizio backup utente $USER, ore $(date)"

tar --force-local -czvf /var/backup/$tar_filename $HOME

echo "Fine backup utente $USER, ore $(date)"

echo "Inizio trasferimento backup alla macchina remota"

scp /var/backup/$tar_filename $machine:$remote_dir

echo "Fine trasferimento backup alla machine remota, ore $(date)"
