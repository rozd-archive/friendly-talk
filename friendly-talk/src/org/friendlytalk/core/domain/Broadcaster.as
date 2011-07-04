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

		//----------------------------------------------------------------------
		//
		//	Properties
		//
		//----------------------------------------------------------------------
		
		//-----------------------------------
		//	Variables: Common
		//-----------------------------------
		
		[Bindable]
		public var name:String;
		
		//-----------------------------------
		//	Variables: Flags
		//-----------------------------------
		
		[Bindable]
		public var audioEnabled:Boolean = true;
		
		[Bindable]
		public var videoEnabled:Boolean = true;
		
		//-----------------------------------
		//	Variables: Flags
		//-----------------------------------
		
		[Bindable]
		[Transient]
		public var stream:NetStream;
	}
}