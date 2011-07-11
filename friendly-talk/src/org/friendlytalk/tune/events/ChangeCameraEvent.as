package org.friendlytalk.tune.events
{
	import flash.events.Event;
	import flash.media.Camera;
	
	public class ChangeCameraEvent extends Event
	{
		public static const CHANGE_CAMERA:String = "changeCamera";
		
		public function ChangeCameraEvent(camera:Camera)
		{
			super(CHANGE_CAMERA);
			
			this._camera = camera;
		}

		private var _camera:Camera;
		
		public function get camera():Camera
		{
			return this._camera;
		}
		
		override public function clone():Event
		{
			return new ChangeCameraEvent(this.camera);
		}
	}
}