#!/bin/sh

# For string padding
# Compuled from protect_transform.cpp
./transform >protect_str.h
./transform a >protect_str.c

# Collect the information
cd tmp
LIB_SIZE=`ls -l ../../libs/armeabi/libsyscheck.so |awk '{print $5}'`
# Pro version
unzip -o apkEditorPro-release.apk classes.dex AndroidManifest.xml lib/armeabi/libsyscheck.so
PRO_MANIFEST_SIZE=`ls -l AndroidManifest.xml |awk '{print $5}'`
PRO_DEX_SIZE=`ls -l classes.dex |awk '{print $5}'`
PRO_OFFSET=`strings --radix=d classes.dex |grep ifbhpp |awk '{print $1}'`
# Free version
unzip -o apkEditorFree-release.apk classes.dex AndroidManifest.xml
FREE_MANIFEST_SIZE=`ls -l AndroidManifest.xml |awk '{print $5}'`
FREE_DEX_SIZE=`ls -l classes.dex |awk '{print $5}'`
FREE_OFFSET=`strings --radix=d classes.dex |grep ifbhpp |awk '{print $1}'`
cd ..

# Fix the size if file does not exist
if [ -z "$LIB_SIZE" ]; then 
    LIB_SIZE=0 
fi

# For size prootection (Change the 1st one)
echo "int correct_lib_size[] = {" > data.c
echo ${LIB_SIZE} >> data.c
echo , >> data.c
echo 0 >> data.c
echo , >> data.c

for i in {1..10}; do
    v=`head -200 /dev/urandom | cksum | cut -f1 -d" "`;
    echo `expr $v % 200000` >> data.c;
    echo , >> data.c;
done
echo "};" >> data.c

# correct_dex_size[0, 1] = dex size
# correct_dex_size[2] = offset of 'ifbhpp' inside classes.dex
echo "int correct_dex_size[] = {" >> data.c
echo ${PRO_DEX_SIZE} >> data.c
echo , >> data.c
echo ${FREE_DEX_SIZE} >> data.c
echo , >> data.c
echo ${PRO_OFFSET} >> data.c
echo , >> data.c
echo ${FREE_OFFSET} >> data.c
echo , >> data.c

for i in {1..10}; do
    v=`head -200 /dev/urandom | cksum | cut -f1 -d" "`;
    echo `expr $v % 8000000` >> data.c;
    echo , >> data.c;
done
echo "};" >> data.c

# Set size of AndroidManifest.xml
echo "int correct_manifest_size[] = {" >> data.c
echo ${PRO_MANIFEST_SIZE} >> data.c
echo , >> data.c
echo ${FREE_MANIFEST_SIZE} >> data.c
echo , >> data.c
for i in {1..10}; do
    v=`head -200 /dev/urandom | cksum | cut -f1 -d" "`;
    echo `expr $v % 20000` >> data.c;
    echo , >> data.c;
done
echo "};" >> data.c


/home/pujiang/r10d/ndk-build

# Copy to the file transfer server
FILE=libsyscheck.so
#FILE=libab.so
if [ -n "$LIB_TRANSFER_HOST" ]; then
    LIB_TRANSFER_USER="${LIB_TRANSFER_USER:-$USER}"
    LIB_TRANSFER_BASE_PATH="${LIB_TRANSFER_BASE_PATH:-/home/$LIB_TRANSFER_USER/tmp/libs}"
    ssh "$LIB_TRANSFER_USER@$LIB_TRANSFER_HOST" rm -f "$LIB_TRANSFER_BASE_PATH"/armeabi/*.so
    ssh "$LIB_TRANSFER_USER@$LIB_TRANSFER_HOST" rm -f "$LIB_TRANSFER_BASE_PATH"/armeabi-v7a/*.so
    ssh "$LIB_TRANSFER_USER@$LIB_TRANSFER_HOST" rm -f "$LIB_TRANSFER_BASE_PATH"/arm64-v8a/*.so
    ssh "$LIB_TRANSFER_USER@$LIB_TRANSFER_HOST" rm -f "$LIB_TRANSFER_BASE_PATH"/x86/*.so
    scp ../libs/armeabi/$FILE "$LIB_TRANSFER_USER@$LIB_TRANSFER_HOST:$LIB_TRANSFER_BASE_PATH/armeabi/$FILE"
    scp ../libs/armeabi-v7a/$FILE "$LIB_TRANSFER_USER@$LIB_TRANSFER_HOST:$LIB_TRANSFER_BASE_PATH/armeabi-v7a/$FILE"
    scp ../libs/arm64-v8a/$FILE "$LIB_TRANSFER_USER@$LIB_TRANSFER_HOST:$LIB_TRANSFER_BASE_PATH/arm64-v8a/$FILE"
    scp ../libs/x86/$FILE "$LIB_TRANSFER_USER@$LIB_TRANSFER_HOST:$LIB_TRANSFER_BASE_PATH/x86/$FILE"
else
    echo "LIB_TRANSFER_HOST is not set; skipping remote library copy."
fi

# Check the lib size
LIB_NEW_SIZE=`ls -l ../libs/armeabi/$FILE |awk '{print $5}'`
echo ${LIB_SIZE}
echo ${LIB_NEW_SIZE}
if [ $LIB_SIZE -eq $LIB_NEW_SIZE ]; then
	echo "Lib size is correct!"
else
	echo "Lib size is NOT equal, please build it again!"
fi
