using System;
using ObjCRuntime;

[assembly: LinkWith ("libWebPWrapper.a", LinkTarget.i386 | LinkTarget.x86_64, SmartLink = true, ForceLoad = true)]
