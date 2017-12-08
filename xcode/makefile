XBUILD=/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild
PROJECT_ROOT=.
PROJECT=$(PROJECT_ROOT)/WebPWrapper.xcodeproj
TARGET=WebPWrapper

all: libWebPWrapper.a

libWebP-sim.a:
	$(XBUILD) -project $(PROJECT) -target $(TARGET) -sdk iphonesimulator11.2 archs="i386 x86_64" -configuration Release clean build
	-mv $(PROJECT_ROOT)/build/Release-iphonesimulator/lib$(TARGET).a $@

libWebP-arm.a:
	$(XBUILD) -project $(PROJECT) -target $(TARGET) -sdk iphoneos11.2 archs="armv7 armv7s arm64" -configuration Release clean build
	-mv $(PROJECT_ROOT)/build/Release-iphoneos/lib$(TARGET).a $@

libWebPWrapper.a: libWebP-sim.a libWebP-arm.a
	lipo -create -output $@ $^
	-rm -f libWebP-sim.a libWebP-arm.a
	-lipo -info libWebPWrapper.a
clean:
	-rm -f *.a *.dll