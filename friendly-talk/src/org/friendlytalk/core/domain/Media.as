package org.friendlytalk.core.domain
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.media.Camera;
	import flash.media.Microphone;
	
	import mx.collections.IList;
	
	public class Media extends EventDispatcher
	{
		public function Media()
		{
			super();
		}
		
		[Bindable]
		public var camera:Camera;
		
		[Bindable]
		public var microphone:Microphone;
		
		[Bindable]
		public var videoMuted:Boolean;
		
		[Bindable]
		public var audioMuted:Boolean;
	}
}