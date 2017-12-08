XBUILD=/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild
PROJECT_ROOT=.
PROJECT=$(PROJECT_ROOT)/WebPWrapper.xcodeproj
TARGET=WebPWrapper

all: libWebPWrapper.a

libWebPWrapper.a: 
	$(XBUILD) -project $(PROJECT) -target $(TARGET) archs="i386 x86_64" -configuration Release clean build
	-mv $(PROJECT_ROOT)/build/Release/lib$(TARGET).a $@

clean:
	-rm -f *.a *.dll