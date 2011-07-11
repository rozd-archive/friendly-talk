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
	
	import org.friendlytalk.core.domain.Media;
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
		
		public var media:Media;
		
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
			
			if (!this.media.videoMuted)
			{
				stream.attachCamera(this.media.camera);
			}
			
			if (!this.media.audioMuted)
			{
				stream.attachAudio(this.media.microphone);
			}
			
			stream.publish(connection.nearID);
			
			return true;
		}
	
		public function changeCamera(stream:NetStream):void
		{
			if (!stream) return;
			
			stream.attachCamera(this.media.camera);
		}
		
		public function muteCamera(stream:NetStream):void
		{
			if (!stream) return;
			
			stream.attachCamera(null);
		}

		public function unmuteCamera(stream:NetStream):void
		{
			if (!stream) return;
			
			stream.attachCamera(this.media.camera);
		}

		public function changeMicrophone(stream:NetStream):void
		{
			if (!stream) return;
			
			stream.attachAudio(this.media.microphone);
		}
		public function muteMicrophone(stream:NetStream):void
		{
			if (!stream) return;
				
			stream.attachAudio(null);
		}

		public function unmuteMicrophone(stream:NetStream):void
		{
			if (!stream) return;
			
			stream.attachAudio(this.media.microphone);
		}
		
		public function getDefaultCamera():Camera
		{
			var cam:Camera = Camera.getCamera();
			
			if (cam)
			{
				cam.setMode(320, 240, 24);
				cam.setQuality(0, 50);
				cam.setKeyFrameInterval(25);
				
//				code for Flash PLayer 11
//				var settings:H264VideoStreamSettings = new H264VideoStreamSettings();
//				settings.setProfileLevel(H264Profile.BASELINE, H264Level.LEVEL_2);
//				
//				stream.videoStreamSettings = settings;
			}
			
			return cam;
		}

		public function getDefaultMicrophone():Microphone
		{
			var mic:Microphone; 
			
			// get enhanced microphone
			
			if (RuntimeUtil.newerThan(10, 3))
			{
				if ("getEnhancedMicrophone" in Microphone)
				{
					mic = Microphone.getEnhancedMicrophone();
				}
			}
			
			// get standard microphone, if enhanced audio fails to initialize
			
			if (!mic)
			{
				mic = Microphone.getMicrophone();
			}
			
			// setup microphone, if it specified
			
			if (mic)
			{
				// http://www.adobe.com/devnet/flashplayer/articles/acoustic-echo-cancellation.html
				
				mic.codec = SoundCodec.SPEEX;
				mic.framesPerPacket = 1;
				mic.setSilenceLevel(0, 2000);
				mic.gain = 50.0;
				
				mic.setUseEchoSuppression(true);
			}
			
			return mic;
		}
	}
}