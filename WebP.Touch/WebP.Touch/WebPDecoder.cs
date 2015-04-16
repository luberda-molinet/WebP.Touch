using System;
using UIKit;
using Foundation;
using System.IO;

namespace WebP.Touch
{
	public class WebPCodec
	{
		private readonly WebPDecoder _decoder;

		public WebPCodec()
		{
			_decoder = new WebPDecoder();
		}

		/// <summary>
		/// Decodes the image for given filepath.
		/// </summary>
		/// <param name="filepath">Filepath to the WebP image.</param>
		/// <returns>An image</returns>
		public UIImage Decode(string filepath)
		{
			return _decoder.ImageWithWebP(filepath);
		}

		/// <summary>
		/// Decodes the image from an iOS NSData.
		/// </summary>
		/// <param name="data">iOS NSData that contains a WebP image.</param>
		/// <returns>An image</returns>
		public UIImage Decode(NSData data)
		{
			return _decoder.ImageWithWebPData(data);
		}

		/// <summary>
		/// Reads given Stream and decodes it as an image.
		/// </summary>
		/// <param name="stream">A readable Stream that contains a WebP image.</param>
		/// <returns>An image</returns>
		public UIImage Decode(Stream stream)
		{
			var data = NSData.FromStream(stream);
			return _decoder.ImageWithWebPData(data);
		}

		/// <summary>
		/// Decodes the specified bytes as an image.
		/// </summary>
		/// <param name="bytes">Byte array that contains a WebP image.</param>
		public UIImage Decode(byte[] bytes)
		{
			var data = NSData.FromArray(bytes);
			return _decoder.ImageWithWebPData(data);
		}

		/// <summary>
		/// Native WebP lib version
		/// </summary>
		/// <value>The native WebP lib version.</value>
		public int Version
		{
			get
			{
				return WebP.Touch.CFunctions.WebPGetDecoderVersion();
			}
		}
	}
}

