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
		
		[Bindable]
		public var camMuted:Boolean;

		[Bindable]
		public var micMuted:Boolean;
		
		//----------------------------------------------------------------------
		//
		//	Methods
		//
		//----------------------------------------------------------------------
		
		public function toggleMic():void
		{
			this.micMuted = !this.micMuted;
		}
		
		public function toggleCam():void
		{
			this.camMuted = !this.camMuted;
		}
	}
}