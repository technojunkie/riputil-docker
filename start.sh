#!/bin/sh
USER=root

# Changing password
if [ "$PASSWORD" != "" ]; then
  echo "$USER:$PASSWORD" | chpasswd
fi

#Adding License Key
if [ ! -e /root/.makemkv ]; then
  mkdir /root/.makemkv
fi
echo "app_Key = \"$LICENSE\"" > /root/.MakeMKV/settings.conf
echo "dvd_MinimumTitleLength = \"3600\"" >> /root/.MakeMKV/settings.conf

#Grab scripts from work dir
if [ -e /work/scripts ]; then
  mkdir /root/bin
  cp /work/scripts/* /usr/local/bin
  chmod +x /usr/local/bin/*
fi

# Starting ssh daemon
/usr/sbin/sshd -D
