/home/pujiang/android-ndk-r10d/ndk-build

TARGET_HOST="${TARGET_HOST:?Set TARGET_HOST to the copy destination host}"
TARGET_USER="${TARGET_USER:-root}"
TARGET_PATH="${TARGET_PATH:-/sda5/pujiang/tmp}"

scp ../libs/x86/libsyscheck.so "${TARGET_USER}@${TARGET_HOST}:${TARGET_PATH}/libsyscheck_x86.so"
scp ../libs/armeabi/libsyscheck.so "${TARGET_USER}@${TARGET_HOST}:${TARGET_PATH}/libsyscheck_arm.so"
