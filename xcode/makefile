XBUILD=/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild
PROJECT_ROOT=.
PROJECT=$(PROJECT_ROOT)/WebPWrapper.xcodeproj
TARGET=WebPWrapper

all: libWebP.a

libWebP-sim.a:
	$(XBUILD) -project $(PROJECT) -target $(TARGET) -sdk iphonesimulator archs="x86_64 i386" -configuration Release clean build
	-mv $(PROJECT_ROOT)/build/Release-iphonesimulator/lib$(TARGET).a $@

libWebP-arm.a:
	$(XBUILD) -project $(PROJECT) -target $(TARGET) -sdk iphoneos archs="arm64 armv7 armv7s" -configuration Release clean build
	-mv $(PROJECT_ROOT)/build/Release-iphoneos/lib$(TARGET).a $@

libWebP.a: libWebP-sim.a libWebP-arm.a
	lipo -create -output $@ $^
	-rm -f libWebP-sim.a libWebP-arm.a
	-lipo -info libWebP.a
clean:
	-rm -f *.a *.dll