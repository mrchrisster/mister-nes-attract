if [ "$(uname -n)" != "MiSTer" ]
then
        echo "This script must be run"
        echo "on a MiSTer system."
        exit 1
fi

if [ ! -f /media/fat/Games/NES/boot1.rom ]
then
        echo "Error: Aborting.."
        echo "Missing file"
        echo "/media/fat/Games/NES/boot1.rom"
        exit 1
fi

echo "Backing up Boot Rom"
cp /media/fat/Games/NES/boot1.rom /media/fat/Games/NES/boot1.rom.bak

nesrandom()
{
    NESrandomrom=$(unzip -Z1 /media/fat/Games/NES/@NES*.zip | grep ".nes" | shuf -n 1 | sed "s/\[\([^]]*\)\]/\\\[\1\\\]/g")
    unzip -p /media/fat/Games/NES/@NES*.zip "$NESrandomrom" > /media/fat/Games/NES/boot1.rom
    echo "$NESrandomrom" > /media/fat/Games/NES/lastplayed.log
    fpga /media/fat/_Console/NES*.rbf
}

mount | grep "on / .*[(,]ro[,$]" -q && RO_ROOT="true"
[ "$RO_ROOT" == "true" ] && mount / -o remount,rw
cat <<\EOF > /etc/init.d/_S95screensaver
#!/bin/sh

trap "" HUP
trap "" TERM

sleepfpga()
{
    sleep 300
    NESrandomrom=$(unzip -Z1 /media/fat/Games/NES/@NES*.zip | grep ".nes" | shuf -n 1 | sed "s/\[\([^]]*\)\]/\\\[\1\\\]/g")
    unzip -p /media/fat/Games/NES/@NES*.zip "$NESrandomrom" > /media/fat/Games/NES/boot1.rom
    cat "$NESrandomrom" > /media/fat/Games/NES/lastplayed.log
    fpga /media/fat/_Console/NES*.rbf
}

start() {
        printf "Starting Screensaver: "
        sleepfpga &
        echo $!>/var/run/nesscreensaver.pid
}

stop() {
        printf "Stopping Screensaver: "
        kill -9 `nesscreensaver.pid`
        rm /var/run/nesscreensaver.pid
        echo "OK"
}

case "$1" in
    start)
        start
        ;;

    stop)
        stop
        ;;

    restart)
        stop
        start
        ;;

    *)
        echo "Usage: /etc/init.d/S95screensaver {start|stop|restart}"
        exit 1
        ;;
esac

exit 0
EOF


mv /etc/init.d/_S95screensaver /etc/init.d/S95screensaver > /dev/null 2>&1
chmod +x /etc/init.d/S95screensaver
sync
[ "$RO_ROOT" == "true" ] && mount / -o remount,ro
sync
/etc/init.d/S95screensaver start

echo "Screensaver is on and"
echo "will launch a random"
echo "game every 5 minutes."
echo ""
echo "If screen stays grey"
echo "game does not work"
echo "as bootrom"
echo ""
echo "Last game played logged at"
echo "/Games/NES/lastplayed.log"
echo ""
echo "Launching in 5s"
sleep 5 && nesrandom
