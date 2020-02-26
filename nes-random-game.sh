randomrom=$(shuf -n 1 /media/fat/Scripts/nes.txt)
unzip -p '/media/fat/Games/NES/@NES - 2019-09-28.zip' "$randomrom" > /media/fat/Games/NES/boot1.rom
fpga /media/fat/_Console/NES*.rbf

