package org.friendlytalk.core.domain
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.NetStream;
	
	public class Broadcaster extends EventDispatcher
	{
		public function Broadcaster()
		{
			super();
		}
		
		[Bindable]
		public var name:String;

		[Bindable]
		public var stream:NetStream;
	}
}