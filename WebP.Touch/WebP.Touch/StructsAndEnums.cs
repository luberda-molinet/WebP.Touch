using System;
using System.Runtime.InteropServices;

namespace WebP.Touch
{
	public static class CFunctions
	{
		// extern int WebPGetDecoderVersion ();
		[DllImport ("__Internal")]
		public static extern int WebPGetDecoderVersion ();
	}
}
