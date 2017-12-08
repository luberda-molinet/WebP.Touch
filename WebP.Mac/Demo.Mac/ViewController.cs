using System;
using System.Net.Http;
using AppKit;
using Foundation;
using CoreGraphics;

namespace Demo.Mac
{
    public partial class ViewController : NSViewController
    {
        public ViewController(IntPtr handle) : base(handle)
        {
        }

        public override void ViewDidLoad()
        {
            base.ViewDidLoad();

            LoadImage();
        }

        public override NSObject RepresentedObject
        {
            get
            {
                return base.RepresentedObject;
            }
            set
            {
                base.RepresentedObject = value;
                // Update the view, if already loaded.
            }
        }

        private async void LoadImage()
        {
            var decoder = new WebP.Mac.WebPCodec();
            var httpClient = new HttpClient();
            using (var stream = await httpClient.GetStreamAsync("http://www.gstatic.com/webp/gallery/1.webp").ConfigureAwait(false))
            {
                var image = decoder.Decode(stream);
                InvokeOnMainThread(() =>
                {
                    var imageView = new NSImageView(new CGRect(0, 0, View.Bounds.Width, View.Bounds.Height));
                    View.AddSubview(imageView);
                    imageView.Image = image;
                });
            }
        }
    }
}
