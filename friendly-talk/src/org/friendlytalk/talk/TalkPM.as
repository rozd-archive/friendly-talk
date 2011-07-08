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
		public var media:Media;
		
		[Bindable("cameraChanged")]
		public function get camera():Camera
		{
			return this.newCamera ? this.newCamera : this.media.camera;
		}
		
		public function get cameras():IList
		{
			if (!Camera.isSupported)
				return null;
			
			return new ArrayList(Camera.names);
		}

		public function get microphones():IList
		{
			if (!Microphone.isSupported)
				return null;
			
			return new ArrayList(Microphone.names);
		}
		
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
		
		public function selectCamera(index:int):void
		{
			if (!Camera.isSupported) 
				return;
			
			if (!Camera.names || Camera.names.length < index) 
				return;
			
			try
			{
				this.newCamera = Camera.getCamera(index.toString());
			}
			catch (error:Error)
			{
				trace(error);
			}
			
			this.dispatchEvent(new Event("cameraChanged"));
		}
		
		public function selectMicrophone(index:int):void
		{
			if (!Microphone.isSupported) 
				return;
			
			if (!Microphone.names || Microphone.names.length < index) 
				return;
			
			try
			{
				this.newMicrophone = Microphone.getMicrophone(index);
			}
			catch (error:Error)
			{
				trace(error);
			}
			
			this.dispatchEvent(new Event("microphoneChanged"));
		}
		
		public function applySettings():void
		{
			if (this.newCamera != this.media.camera)
			{
				
			}

			if (this.newMicrophone != this.media.microphone)
			{
				
			}
			
			this.newCamera = null;
			this.newMicrophone = null;
		}

		public function declineSettings():void
		{
			this.newCamera = null;
			this.newMicrophone = null;
		}
	}
}