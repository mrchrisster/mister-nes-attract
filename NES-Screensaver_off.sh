if [ "$(uname -n)" != "MiSTer" ]
then
        echo "This script must be run"
        echo "on a MiSTer system."
        exit 1
fi

mount | grep -q "on / .*[(,]ro[,$]" && RO_ROOT="true"
[ "$RO_ROOT" == "true" ] && mount / -o remount,rw
mv /etc/init.d/S95screensaver /etc/init.d/_S95screensaver > /dev/null 2>&1
sync
[ "$RO_ROOT" == "true" ] && mount / -o remount,ro
echo "Restoring boot.rom"
cp /media/fat/Games/NES/boot1.rom.bak /media/fat/Games/NES/boot1.rom
rm /media/fat/Games/NES/boot1.rom.bak

echo "Screensaver is off and"
echo "inactive at startup."
echo "Done!"
echo "Rebooting in 5s"
sync
sleep 5 && reboot now
exit 0
