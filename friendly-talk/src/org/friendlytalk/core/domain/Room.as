package org.friendlytalk.core.domain
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	
	public class Room extends EventDispatcher
	{
		public function Room(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		[Bindable]
		public var connected:Boolean = false;

		[Bindable]
		public var connecting:Boolean = false;
		
		[Bindable]
		public var broadcasters:IList = new ArrayList();
		
		[Bindable]
		public var favorite:Boolean;
	}
}