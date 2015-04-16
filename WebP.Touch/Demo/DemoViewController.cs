using System;
using System.Drawing;

using Foundation;
using UIKit;
using System.Net;
using System.Net.Http;

namespace Demo
{
	public partial class DemoViewController : UIViewController
	{
		public DemoViewController(IntPtr handle)
			: base(handle)
		{
		}

		public override void DidReceiveMemoryWarning()
		{
			// Releases the view if it doesn't have a superview.
			base.DidReceiveMemoryWarning();
			
			// Release any cached data, images, etc that aren't in use.
		}

		#region View lifecycle

		public override void ViewDidLoad()
		{
			base.ViewDidLoad();
			
			LoadImage();
		}

		private async void LoadImage()
		{
			var decoder = new WebP.Touch.WebPCodec();
			var httpClient = new HttpClient();
			using (var stream = await httpClient.GetStreamAsync("http://www.gstatic.com/webp/gallery/1.webp").ConfigureAwait(false))
			{
				var image = decoder.Decode(stream);
				InvokeOnMainThread(() =>
					{
						View = new UIImageView(image);
					});
			}
		}

		public override void ViewWillAppear(bool animated)
		{
			base.ViewWillAppear(animated);
		}

		public override void ViewDidAppear(bool animated)
		{
			base.ViewDidAppear(animated);
		}

		public override void ViewWillDisappear(bool animated)
		{
			base.ViewWillDisappear(animated);
		}

		public override void ViewDidDisappear(bool animated)
		{
			base.ViewDidDisappear(animated);
		}

		#endregion
	}
}

