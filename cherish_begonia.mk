#
# Copyright (C) 2021 The cherishOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Release name
PRODUCT_RELEASE_NAME := begonia

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_p.mk)

# Inherit from begonia device
$(call inherit-product, device/redmi/begonia/device.mk)

# Inherit some common riceDroid stuff
$(call inherit-product, vendor/cherish/config/common_full_phone.mk)
TARGET_SUPPORTS_QUICK_TAP := true


# Inherit some extras stuff
$(call inherit-product-if-exists, vendor/extras/extras.mk)

# Screen density
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Boot Animation
TARGET_SCREEN_HEIGHT := 2340
TARGET_SCREEN_WIDTH := 1080
USE_PIXEL_CHARGING := true
TARGET_INCLUDE_CARRIER_SETTINGS := true
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.cherish.maintainer=decoder

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := begonia
PRODUCT_NAME := cherish_begonia
PRODUCT_BRAND := Redmi
PRODUCT_MODEL := Redmi Note 8 Pro
PRODUCT_MANUFACTURER := Xiaomi

BUILD_FINGERPRINT := "Redmi/begonia/begonia:11/RP1A.200720.011/V12.5.8.0.RGGMIXM:user/release-keys"

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="begonia-user 11 RP1A.200720.011 V12.5.8.0.RGGMIXM release-keys" \
    PRODUCT_NAME="begonia" \
    TARGET_DEVICE="begonia"

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi
