ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:10.0
DEBUG = 0
GO_EASY_ON_ME = 1
FINALPACKAGE = 1
#CFLAGS = -fobjc-arc
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = VibratingFlashlight
VibratingFlashlight_FILES = Tweak.xm
VibratingFlashlight_FRAMEWORKS = UIKit Foundation AudioToolbox
VibratingFlashlight_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
