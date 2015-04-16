# WebP.Touch
Xamarin iOS bindings for WebP decoding
NuGet package can be found here: https://www.nuget.org/packages/WebP.Touch

# WebP framework
Original WebP framework comes from http://downloads.webmproject.org/releases/webp/index.html
Content is extracted from the framework and bindings are created for the native libraries.
Currently we use libwebp-0.4.3
To build the library download the tar.gz file, extract it and run the “iosbuild.sh” script. 
This will create the WebP.framework. Renaming the "WebP" file to "WebP.a" will give the static library
that is used inside this binding library

# XCode wrapper project
This project is used to expose some simple methods to use the original WebP.framework
At the moment it will only expose methods for decoding

# Original project
Some inspiration came from WebP decoding project from Sean Ooi
https://github.com/seanooi/iOS-WebP
