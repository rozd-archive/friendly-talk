package org.friendlytalk.tune.presentation
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.media.Camera;
	import flash.media.Microphone;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	
	import org.friendlytalk.core.domain.Media;
	import org.friendlytalk.tune.events.ChangeCameraEvent;
	import org.friendlytalk.tune.events.ChangeMicrophoneEvent;
	
	/**
	 * @eventType org.friendlytalk.settings.events.ChangeCameraEvent.CHANGE_CAMERA
	 */
	[Event(name="changeCamera", type="org.friendlytalk.tune.events.ChangeCameraEvent")]
	
	/**
	 * @eventType org.friendlytalk.settings.events.ChangeMicrophoneEvent.CHANGE_MICROPHONE
	 */
	[Event(name="changeMicrophone", type="org.friendlytalk.tune.events.ChangeMicrophoneEvent")]
	
	public class TunePM extends EventDispatcher
	{
		public function TunePM(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		//----------------------------------------------------------------------
		//
		//	Variables
		//
		//----------------------------------------------------------------------
		
		private var newCamera:Camera;

		private var newMicrophone:Microphone;
		
		private var applyImmediately:Boolean = true;
		
		//----------------------------------------------------------------------
		//
		//	Properties
		//
		//----------------------------------------------------------------------
		
		public var media:Media;
		
		[Bindable("cameraChanged")]
		public function get camera():Camera
		{
			return this.newCamera ? this.newCamera : this.media.camera;
		}

		[Bindable("microphoneChanged")]
		public function get microphone():Microphone
		{
			return this.newMicrophone ? this.newMicrophone : this.media.microphone;
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
			
			if (this.applyImmediately) this.applySettings();
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
			
			if (this.applyImmediately) this.applySettings();
		}
		
		public function applySettings():void
		{
			if (this.newCamera != this.media.camera)
			{
				this.dispatchEvent(new ChangeCameraEvent(this.newCamera));
			}
			
			if (this.newMicrophone != this.media.microphone)
			{
				this.dispatchEvent(new ChangeMicrophoneEvent(this.newMicrophone));
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