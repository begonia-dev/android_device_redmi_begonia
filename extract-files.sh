#!/bin/bash
#
# Copyright (C) 2018-2019 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=begonia
VENDOR=redmi

INITIAL_COPYRIGHT_YEAR=2019

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

POTATO_ROOT="${MY_DIR}"/../../..

HELPER="${POTATO_ROOT}/vendor/potato/build/tools/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

SECTION=
KANG=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
    *.rc)
        sed -i "s/vendor\/lib\/modules\//vendor\/lib\/modules_prebuilt\//g" ${2}
        ;;
    vendor/lib/hw/android.hardware.keymaster@3.0-impl.so)
        patchelf --replace-needed libkeymaster_portable.so libkeymaster_portable-v29.so ${2}
        patchelf --replace-needed libsoftkeymasterdevice.so libsoftkeymasterdevice-v29.so ${2}
        patchelf --replace-needed libpuresoftkeymasterdevice.so libpuresoftkeymasterdevice-v29.so ${2}
        ;;
    vendor/lib64/hw/android.hardware.keymaster@3.0-impl.so)
        patchelf --replace-needed libkeymaster_portable.so libkeymaster_portable-v29.so ${2}
        patchelf --replace-needed libsoftkeymasterdevice.so libsoftkeymasterdevice-v29.so ${2}
        patchelf --replace-needed libpuresoftkeymasterdevice.so libpuresoftkeymasterdevice-v29.so ${2}
        ;;
    vendor/lib/libkeymaster3device.so)
        patchelf --replace-needed libkeymaster_portable.so libkeymaster_portable-v29.so ${2}
        patchelf --replace-needed libsoftkeymasterdevice.so libsoftkeymasterdevice-v29.so ${2}
        patchelf --replace-needed libpuresoftkeymasterdevice.so libpuresoftkeymasterdevice-v29.so ${2}
        ;;
    vendor/lib64/libkeymaster3device.so)
        patchelf --replace-needed libkeymaster_portable.so libkeymaster_portable-v29.so ${2}
        patchelf --replace-needed libsoftkeymasterdevice.so libsoftkeymasterdevice-v29.so ${2}
        patchelf --replace-needed libpuresoftkeymasterdevice.so libpuresoftkeymasterdevice-v29.so ${2}
        ;;
    vendor/lib64/hw/audio.primary.mt6785.so)
        patchelf --replace-needed libmedia_helper.so libmedia_helper-v29.so ${2}
        ;;
    vendor/lib/hw/audio.primary.mt6785.so)
        patchelf --replace-needed libmedia_helper.so libmedia_helper-v29.so ${2}
        ;;
    vendor/lib64/vendor.mediatek.hardware.audio@5.1.so)
        patchelf --replace-needed android.hardware.audio@5.0.so android.hardware.audio@5.0-v29.so ${2}
        patchelf --replace-needed android.hardware.audio.common@5.0.so android.hardware.audio.common@5.0-v29.so ${2}
        patchelf --replace-needed android.hardware.audio.effect@5.0.so android.hardware.audio.effect@5.0-v29.so ${2}
	;;
    vendor/lib/vendor.mediatek.hardware.audio@5.1.so)
        patchelf --replace-needed android.hardware.audio@5.0.so android.hardware.audio@5.0-v29.so ${2}
        patchelf --replace-needed android.hardware.audio.common@5.0.so android.hardware.audio.common@5.0-v29.so ${2}
        patchelf --replace-needed android.hardware.audio.effect@5.0.so android.hardware.audio.effect@5.0-v29.so ${2}
	;;
    esac
}

# Initialize the helper for common device
setup_vendor "${DEVICE}" "${VENDOR}" "${POTATO_ROOT}" true "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" \
        "${KANG}" --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh"
