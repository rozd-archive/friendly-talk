package org.friendlytalk.core.infrastructure
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.MicrophoneEnhancedOptions;
	import flash.media.SoundCodec;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.Capabilities;
	
	import org.friendlytalk.utils.RuntimeUtil;

	public class Publisher extends EventDispatcher 
	{
		//----------------------------------------------------------------------
		//
		//	Constructor
		//
		//----------------------------------------------------------------------
		
		public function Publisher()
		{
		}
		
		//----------------------------------------------------------------------
		//
		//	Variables
		//
		//----------------------------------------------------------------------
		
		private var stream:NetStream;
		
		//----------------------------------------------------------------------
		//
		//	Properties
		//
		//----------------------------------------------------------------------
		
		[Bindable]
		public var camera:Camera;

		[Bindable]
		public var microphone:Microphone;
		
		//----------------------------------------------------------------------
		//
		//	Methods
		//
		//----------------------------------------------------------------------
		
		/**
		 * Starts publishing video and audio through specified NetStream.
		 * 
		 * @param
		 * @param
		 * 
		 * @return <code>true</code> - if all okay, <code>false</code> - if 
		 * something wrong.
		 */
		public function publish(connection:NetConnection, stream:NetStream, cam:Boolean=true, mic:Boolean=true):Boolean
		{
			if (!connection || !stream) return false;
			
			if (!this.camera)
				this.camera = Camera.getCamera();
			
			if (this.camera)
			{
				this.camera.setMode(320, 240, 24);
				this.camera.setQuality(0, 50);
				this.camera.setKeyFrameInterval(25);
				
				if (cam)
					stream.attachCamera(this.camera);
				
//				code for Flash PLayer 11
//				var settings:H264VideoStreamSettings = new H264VideoStreamSettings();
//				settings.setProfileLevel(H264Profile.BASELINE, H264Level.LEVEL_2);
//				
//				stream.videoStreamSettings = settings;
			}
			
			// get enhanced microphone
			
			if (RuntimeUtil.newerThan(10, 3))
			{
				if ("getEnhancedMicrophone" in Microphone)
				{
					this.microphone = Microphone.getEnhancedMicrophone();
				}
			}
			
			// get standard microphone, if enhanced audio fails to initialize
			
			if (!this.microphone)
			{
				this.microphone = Microphone.getMicrophone();
			}
			
			// setup microphone, if it specified
			
			if (this.microphone)
			{
				// http://www.adobe.com/devnet/flashplayer/articles/acoustic-echo-cancellation.html
				
				this.microphone.codec = SoundCodec.SPEEX;
				this.microphone.framesPerPacket = 1;
				this.microphone.setSilenceLevel(0, 2000);
				this.microphone.gain = 50.0;

				this.microphone.setUseEchoSuppression(true);

				if (mic)
					stream.attachAudio(this.microphone);
			}
			
			stream.publish(connection.nearID);
			
			return true;
		}
	
		public function muteCamera(stream:NetStream):void
		{
			if (!stream) return;
			
			stream.attachCamera(null);
		}

		public function unmuteCamera(stream:NetStream):void
		{
			if (!stream) return;
			
			stream.attachCamera(this.camera);
		}

		public function muteMicrophone(stream:NetStream):void
		{
			if (!stream) return;
				
			stream.attachAudio(null);
		}

		public function unmuteMicrophone(stream:NetStream):void
		{
			if (!stream) return;
			
			stream.attachAudio(this.microphone);
		}
	}
}