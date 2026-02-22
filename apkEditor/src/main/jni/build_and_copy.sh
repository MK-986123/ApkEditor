/home/pujiang/android-ndk-r10d/ndk-build

TARGET_HOST="${TARGET_HOST:?TARGET_HOST must be set. Example: export TARGET_HOST=your-copy-host}"
TARGET_USER="${TARGET_USER:-root}"
TARGET_PATH="${TARGET_PATH:?TARGET_PATH must be set to the destination directory}"

scp ../libs/x86/libsyscheck.so "${TARGET_USER}@${TARGET_HOST}:${TARGET_PATH}/libsyscheck_x86.so"
scp ../libs/armeabi/libsyscheck.so "${TARGET_USER}@${TARGET_HOST}:${TARGET_PATH}/libsyscheck_arm.so"
