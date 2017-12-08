using System;
using System.IO;
using AppKit;
using Foundation;

namespace WebP.Mac
{
    /// <summary>
    /// WebPCodec.
    /// </summary>
    public class WebPCodec
    {
        private readonly WebPDecoder _decoder;

        /// <summary>
        /// Initializes a new instance of the <see cref="T:WebP.Touch.WebPCodec"/> class.
        /// </summary>
        public WebPCodec()
        {
            _decoder = new WebPDecoder();
        }

        /// <summary>
        /// Decodes the image for given filepath.
        /// </summary>
        /// <param name="filepath">Filepath to the WebP image.</param>
        /// <returns>An image</returns>
        public NSImage Decode(string filepath)
        {
            NSError error = null;
            var result = _decoder.ImageWithWebP(filepath, out error);
            if (error != null)
                throw new NSErrorException(error);
            return result;
        }

        /// <summary>
        /// Decodes the image from an iOS NSData.
        /// </summary>
        /// <param name="data">iOS NSData that contains a WebP image.</param>
        /// <returns>An image</returns>
        public NSImage Decode(NSData data)
        {
            NSError error = null;
            var result = _decoder.ImageWithWebPData(data, out error);
            if (error != null)
                throw new NSErrorException(error);
            return result;
        }

        /// <summary>
        /// Reads given Stream and decodes it as an image.
        /// </summary>
        /// <param name="stream">A readable Stream that contains a WebP image.</param>
        /// <returns>An image</returns>
        public NSImage Decode(Stream stream)
        {
            NSError error = null;
            using (var data = NSData.FromStream(stream))
            {
                var result = _decoder.ImageWithWebPData(data, out error);
                if (error != null)
                    throw new NSErrorException(error);
                return result;
            }
        }

        /// <summary>
        /// Decodes the specified bytes as an image.
        /// </summary>
        /// <param name="bytes">Byte array that contains a WebP image.</param>
        public NSImage Decode(byte[] bytes)
        {
            NSError error = null;
            using (var data = NSData.FromArray(bytes))
            {
                var result = _decoder.ImageWithWebPData(data, out error);
                if (error != null)
                    throw new NSErrorException(error);
                return result;
            }
        }

        /// <summary>
        /// Native WebP lib version
        /// </summary>
        /// <value>The native WebP lib version.</value>
        public int Version
        {
            get
            {
                return _decoder.GetVersion();
            }
        }
    }
}
