using System;
using ObjCRuntime;

[assembly: LinkWith ("WebP.a", LinkTarget.i386 | LinkTarget.x86_64, SmartLink = true, ForceLoad = true)]
