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
        ;&
    vendor/lib64/hw/android.hardware.keymaster@3.0-impl.so)
        ;&
    vendor/lib/libkeymaster3device.so)
        ;&
    vendor/lib64/libkeymaster3device.so)
        patchelf --replace-needed libkeymaster_portable.so libkeymaster_portable-v29.so ${2}
        patchelf --replace-needed libsoftkeymasterdevice.so libsoftkeymasterdevice-v29.so ${2}
        patchelf --replace-needed libpuresoftkeymasterdevice.so libpuresoftkeymasterdevice-v29.so ${2}
        ;;
    vendor/lib64/hw/audio.primary.mt6785.so)
        ;&
    vendor/lib/hw/audio.primary.mt6785.so)
        patchelf --replace-needed libmedia_helper.so libmedia_helper-v29.so ${2}
        ;;
    vendor/lib64/libmtkcam_prerelease.so)
        ;&
    vendor/lib64/libmtkcam_device3.so)
        ;&
    vendor/lib64/libmtkcam_hwutils.so)
        ;&
    vendor/lib64/libmtkcam_pipeline.so)
        ;&
    vendor/lib64/libmfllcore.so)
        ;&
    vendor/lib64/libhwc2on1adapter.so)
        ;&
    vendor/lib64/libmtkcam_3rdparty.mtk.so)
        ;&
    vendor/lib64/hw/android.hardware.graphics.composer@2.1-impl.so)
        ;&
    vendor/lib64/hw/audio.bluetooth.default.so)
        ;&
    vendor/lib64/libmtkcam_debugutils.so)
        ;&
    vendor/lib64/libmtkcam_pipelinemodel.so)
        ;&
    vendor/lib64/libvidhance.so)
        ;&
    vendor/bin/hw/android.hardware.wifi@1.0-service-lazy-mediatek)
        ;&
    vendor/bin/hw/hostapd)
        ;&
    vendor/bin/hw/wpa_supplicant)
        patchelf --add-needed libcompiler_rt.so ${2}
        ;;
    vendor/lib64/libarmnn.so)
        patchelf --add-needed libunwindstack.so ${2}
        ;;

    esac
}

# Initialize the helper for common device
setup_vendor "${DEVICE}" "${VENDOR}" "${POTATO_ROOT}" true "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" \
        "${KANG}" --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh"
