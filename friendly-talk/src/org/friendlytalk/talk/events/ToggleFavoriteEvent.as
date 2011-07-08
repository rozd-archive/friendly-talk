package org.friendlytalk.talk.events
{
	import flash.events.Event;
	
	public class ToggleFavoriteEvent extends Event
	{
		public static const TOGGLE_FAVORITE:String = "toggleFavorite";
		
		public function ToggleFavoriteEvent()
		{
			super(TOGGLE_FAVORITE);
		}
		
		override public function clone():Event
		{
			return new ToggleFavoriteEvent();
		}
	}
}