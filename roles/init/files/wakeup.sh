#!/bin/bash
# Managed by jamlab-ansible

# Script to run on boot
ANSIBLE_EXEC_DEST=/usr/local/sbin
ANSIBLE_EXEC_NAME=jamlab-ansible-update

if [ ! -e $ANSIBLE_EXEC_DEST/$ANSIBLE_EXEC_NAME]
then
    echo -e "$ANSIBLE_EXEC_DEST/$ANSIBLE_EXEC_NAME not found!" >&2
    exit 1
fi

$ANSIBLE_EXEC_DEST/$ANSIBLE_EXEC_NAME
