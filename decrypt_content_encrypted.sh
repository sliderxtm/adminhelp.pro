#!/bin/sh

filename_in=$1

HOST=`hostname`
secret="/home/backup/pass.key"

openssl enc -d -aes-256-cbc -pass file:$secret -in $filename_in | tar -xz
