package org.friendlytalk.settings.events
{
	import flash.events.Event;
	import flash.media.Microphone;
	
	public class ChangeMicrophoneEvent extends Event
	{
		public static const CHANGE_MICROPHONE:String = "changeMicrophone";
		
		public function ChangeMicrophoneEvent(microphone:Microphone)
		{
			super(CHANGE_MICROPHONE);
			
			this._microphone = microphone;
		}

		private var _microphone:Microphone;
		
		public function get microphone():Microphone
		{
			return this._microphone;
		}
		
		override public function clone():Event
		{
			return new ChangeMicrophoneEvent(this.microphone);
		}
	}
}