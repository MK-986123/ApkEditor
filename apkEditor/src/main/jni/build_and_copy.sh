/home/pujiang/android-ndk-r10d/ndk-build

TARGET_HOST="${TARGET_HOST:?TARGET_HOST must be set}"
TARGET_USER="${TARGET_USER:?TARGET_USER must be set}"
TARGET_PATH="${TARGET_PATH:?TARGET_PATH must be set to the destination directory}"
case "$TARGET_HOST" in
  (*[!A-Za-z0-9.-]*) echo "TARGET_HOST contains unsupported characters"; exit 1 ;;
esac
case "$TARGET_USER" in
  (*[!A-Za-z0-9_.-]*) echo "TARGET_USER contains unsupported characters"; exit 1 ;;
esac
case "$TARGET_PATH" in
  (*[!A-Za-z0-9_./-]*) echo "TARGET_PATH contains unsupported characters; only alphanumeric, dots, underscores, slashes, and hyphens are allowed"; exit 1 ;;
esac

scp "../libs/x86/libsyscheck.so" "${TARGET_USER}@${TARGET_HOST}:${TARGET_PATH}/libsyscheck_x86.so"
scp "../libs/armeabi/libsyscheck.so" "${TARGET_USER}@${TARGET_HOST}:${TARGET_PATH}/libsyscheck_arm.so"
