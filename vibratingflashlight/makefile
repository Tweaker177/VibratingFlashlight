ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:9.0
DEBUG = 0
#CFLAGS = -fobc-arc
FINALPACKAGE = 1
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = VibratingFlashlight
VibratingFlashlight_FILES = VFLRootListController.m
VibratingFlashlight_INSTALL_PATH = /Library/PreferenceBundles
VibratingFlashlight_FRAMEWORKS = UIKit Foundation Social
VibratingFlashlight_PRIVATE_FRAMEWORKS = Preferences
VibratingFlashlight_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/VibratingFlashlight.plist$(ECHO_END)
