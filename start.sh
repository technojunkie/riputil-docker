#!/bin/sh
USER=root

# Changing password
if [ "$PASSWORD" != "" ]; then
  echo "$USER:$PASSWORD" | chpasswd
fi

#Adding License Key
if [! -e /root/.makemkv ]; then
  mkdir /root/.makemkv
fi
echo "app_Key =\"$LICENSE\"" > /root/.makemkv/settings.conf

# Starting ssh daemon
/usr/sbin/sshd -D
