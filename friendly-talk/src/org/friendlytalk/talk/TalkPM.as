package org.friendlytalk.talk
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.media.Camera;
	
	import mx.collections.IList;
	
	public class TalkPM extends EventDispatcher
	{
		//----------------------------------------------------------------------
		//
		//	Constructor
		//
		//----------------------------------------------------------------------
		
		public function TalkPM()
		{
			super();
		}
		
		//----------------------------------------------------------------------
		//
		//	Properties
		//
		//----------------------------------------------------------------------
		
		[Bindable]
		public var broadcasters:IList;

		[Bindable]
		public var camera:Camera;
		
		//----------------------------------------------------------------------
		//
		//	Methods
		//
		//----------------------------------------------------------------------
		
	}
}