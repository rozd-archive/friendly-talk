package org.friendlytalk.home.events
{
	import flash.events.Event;
	
	public class ConnectEvent extends Event
	{
		public static const CONNECT:String = "connect";
		
		public function ConnectEvent(room:String=null)
		{
			super(CONNECT, bubbles, cancelable);
			
			this._room = room;
		}
		
		private var _room:String;
		
		public function get room():String
		{
			return this._room;
		}
	}
}