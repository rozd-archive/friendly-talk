package org.friendlytalk.talk
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.media.Camera;
	import flash.media.Microphone;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	
	import org.friendlytalk.core.domain.Media;
	import org.friendlytalk.core.domain.Room;
	import org.friendlytalk.talk.events.ToggleCameraEvent;
	import org.friendlytalk.talk.events.ToggleFavoriteEvent;
	import org.friendlytalk.talk.events.ToggleMicrophoneEvent;
	import org.friendlytalk.tune.presentation.TunePM;
	
	/**
	 * @eventType org.friendlytalk.talk.events.ToggleMicrophoneEvent.TOGGLE_MICROPHONE
	 */
	[Event(name="toggleMicrophone", type="org.friendlytalk.talk.events.ToggleMicrophoneEvent")]

	/**
	 * @eventType org.friendlytalk.talk.events.ToggleMicrophoneEvent.TOGGLE_CAMERA
	 */
	[Event(name="toggleCamera", type="org.friendlytalk.talk.events.ToggleCameraEvent")]
	
	/**
	 * @eventType org.friendlytalk.talk.events.ToggleMicrophoneEvent.TOGGLE_FAVORITE
	 */
	[Event(name="toggleFavorite", type="org.friendlytalk.talk.events.ToggleFavoriteEvent")]
	
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
		//	Varaibles
		//
		//----------------------------------------------------------------------
		
		private var newCamera:Camera;

		private var newMicrophone:Microphone;
		
		//----------------------------------------------------------------------
		//
		//	Properties
		//
		//----------------------------------------------------------------------
		
		[Bindable]
		public var broadcasters:IList;

		[Bindable]
		public var room:Room;

		[Bindable]
		public var tunePM:TunePM;
		
		//----------------------------------------------------------------------
		//
		//	Methods
		//
		//----------------------------------------------------------------------
		
		public function toggleMic():void
		{
			this.dispatchEvent(new ToggleMicrophoneEvent());
		}
		
		public function toggleCam():void
		{
			this.dispatchEvent(new ToggleCameraEvent());
		}
		
		public function toggleFav():void
		{
			this.dispatchEvent(new ToggleFavoriteEvent());
		}
	}
}