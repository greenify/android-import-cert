#!/bin/bash

# instructions according to http://wiki.cacert.org/FAQ/ImportRootCert

file="$1"
androidTemp="/storage/sdcard1/tempiii"

hash=$(openssl x509 -inform PEM -subject_hash_old -in "$file" | head -1)
cat "$file" > "$hash".0
openssl x509 -inform PEM -text -in "$file" -out /dev/null >> "$hash".0

# push to android

adb push "$file" "$androidTemp"
# Make the /system folder writable 
adb shell su -c "mount -o remount,rw /system"

adb shell su -c "cp '$androidTemp' /system/etc/security/cacerts/$hash.0"
adb shell su -c "chmod 644 /system/etc/security/cacerts/$hash.0"

echo "Please reboot to apply your changes"
