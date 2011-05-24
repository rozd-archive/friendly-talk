package org.friendlytalk.core.infrastructure.events
{
	import flash.events.Event;
	
	public class ConnectorEvent extends Event
	{
		public static const SUCCESS:String				= "success";
		public static const ERROR:String				= "error";
		public static const NET_STATUS:String				= "netStatus";
		
		
		
		public function ConnectorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}