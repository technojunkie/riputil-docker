#!/bin/sh
USER=root

# Changing password
if ["$PASSWORD" != ""]; then
  echo "$USER:$PASSWORD" | chpasswd
fi

#set activation code dor makeMKV
if ["LICENSE" != ""]; then
  #apply license key
  sed 's/.*app_Key.*/app_Key = "$LICENSE"/' /root/.MakeMKV/settings.conf
fi

if ["MINLENGTH" = ""]; then
  #set default to 1 hour
  sed 's/.*dvd_MinimumTitleLength.*/dvd_MinimumTitleLength = "3600"/' /root/.MakeMKV/settings.conf
else
  sed 's/.*dvd_MinimumTitleLength.*/dvd_MinimumTitleLength = "$MINLENGTH"/' /root/.MakeMKV/settings.conf
fi


# Starting ssh daemon
/usr/sbin/sshd -D
