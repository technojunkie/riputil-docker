#!/bin/sh
USER=root

# Changing password
if [ "$PASSWORD" != "" ]; then
  echo "$USER:$PASSWORD" | chpasswd
fi

# Starting ssh daemon
/usr/sbin/sshd -D
