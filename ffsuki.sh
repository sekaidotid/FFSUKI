#!/bin/bash

# Default Configuration, You Can Change This.

# Input Your Name / Fansub / Fanshare
default_fansub="SEKAI DOT ID"

# CRF (Constant Rate Factor)
default_quality="25"

# Video Bit
# 8-Bit : yuv444p
# 10-Bit : yuv444p10le
# 12-Bit : yuv444p12le
# 14-Bit : yuv444p14le
# 16-Bit : yuv444p16le
default_pix_fmt="yuv444p"

# ISO 639-2 Language Code
default_lang="ind"

######################################################################
# Warning!. not recommended to change the code below, unless you understand what you are doing
######################################################################

prog="FFSUKI"
ver="Version 0.7"
motto="Make Hardsub Its Easy!"

fansub=$(whiptail --nocancel --title "$prog - $ver" --inputbox \
  "Input Your Name / Your Fansub Name" 20 70 "$default_fansub" \
3>&1 1>&2 2>&3)

vid=$(whiptail --nocancel --title "$prog - $ver" --menu \
  "Choose Video Format" 20 70 10 \
  "libx264" "H264 Video Format. Safest choice for compatibility" \
  "libx265" "H265 Video Format. Next generation video format" \
3>&1 1>&2 2>&3)

res=$(whiptail --nocancel --title "$prog - $ver" --menu \
  "Choose Video Resolution" 20 70 10 \
  "640:360" "nHD" \
  "960:540" "qHD" \
  "1280:720" "HD" \
  "1920:1080" "FHD" \
  "2560:1440" "WQHD" \
  "3840:2160" "UHD" \
3>&1 1>&2 2>&3)

for i in *.mkv; do
ffmpeg -i "$i" -filter_complex "scale=$res,subtitles='$i'" -c:v $vid -preset veryslow -crf $default_quality -pix_fmt $default_pix_fmt -c:a aac -b:a 384k process/"$prog-${i%.*}.mp4"
crc=$(crc32 process/"$prog-${i%.*}.mp4")
mv process/"$prog-${i%.*}.mp4" output/"[${fansub^^}]-${i%.*}-[$res][$vid][$default_pix_fmt][${crc^^}].mp4"
done
