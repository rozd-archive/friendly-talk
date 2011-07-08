package org.friendlytalk.talk.events
{
	import flash.events.Event;
	
	public class ToggleCameraEvent extends Event
	{
		public static const TOGGLE_CAMERA:String = "toggleCamera";
		
		public function ToggleCameraEvent()
		{
			super(TOGGLE_CAMERA);
		}
		
		override public function clone():Event
		{
			return new ToggleCameraEvent();
		}
	}
}