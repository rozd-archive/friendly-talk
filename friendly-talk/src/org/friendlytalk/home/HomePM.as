package org.friendlytalk.home
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.friendlytalk.core.domain.Room;
	import org.friendlytalk.home.events.ConnectEvent;
	
	[Event(name="connect", type="org.friendlytalk.home.events.ConnectEvent")]
	
	public class HomePM extends EventDispatcher
	{
		public function HomePM()
		{
			super();
		}
		
		//----------------------------------------------------------------------
		//
		//	Properties
		//
		//----------------------------------------------------------------------
		
		[Bindable]
		public var room:Room;
		
		//----------------------------------------------------------------------
		//
		//	Methods
		//
		//----------------------------------------------------------------------
		
		public function connect(room:String=null):void
		{
			this.dispatchEvent(new ConnectEvent(room));
		}
	}
}