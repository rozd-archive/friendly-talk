package org.friendlytalk.talk.events
{
	import flash.events.Event;
	
	public class ToggleMicrophoneEvent extends Event
	{
		public static const TOGGLE_MICROPHONE:String = "toggleMicrophone";
		
		public function ToggleMicrophoneEvent()
		{
			super(TOGGLE_MICROPHONE);
		}
		
		override public function clone():Event
		{
			return new ToggleMicrophoneEvent();
		}
	}
}