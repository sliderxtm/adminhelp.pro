#!/bin/sh

filename_in=$1
filename_out=$2

HOST=`hostname`
secret="/home/backup/pass.key"

openssl enc -d -aes-256-cbc -pass file:$secret -in $filename_in -out $filename_out



