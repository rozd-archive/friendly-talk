package org.friendlytalk.core.infrastructure
{
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.MicrophoneEnhancedOptions;
	import flash.media.SoundCodec;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.Capabilities;

	public class Publisher
	{
		private static function runtimeNewestThan(major:uint, minor:uint=0, build:uint=0):Boolean
		{
			var version:Array = Capabilities.version.match(/\d+/g);
			
			if (major > Number(version[0]) || 
				minor > Number(version[1]) || 
				build > Number(version[2]))
			{
				return false;
			}
			
			return true;
		}
		
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
		public function publish(connection:NetConnection, stream:NetStream):Boolean
		{
			if (!connection || !stream) return false;
			
			var cam:Camera = Camera.getCamera();
			
			if (cam)
			{
				cam.setMode(320, 240, 24);
				cam.setQuality(0, 50);
				cam.setKeyFrameInterval(25);
				
				stream.attachCamera(cam);
				
//				code for Flash PLayer 11
//				var settings:H264VideoStreamSettings = new H264VideoStreamSettings();
//				settings.setProfileLevel(H264Profile.BASELINE, H264Level.LEVEL_2);
//				
//				stream.videoStreamSettings = settings;
			}
			
			var mic:Microphone;
			
			// get enhanced microphone
			
			if (runtimeNewestThan(10, 3))
			{
				if ("getEnhancedMicrophone" in Microphone)
				{
					mic = Microphone.getEnhancedMicrophone();
				}
			}
			
			// get standard microphone
			
			if (!mic)
			{
				mic = Microphone.getMicrophone();
			}
			
			// setup microphone
			
			if (mic)
			{
				// http://www.adobe.com/devnet/flashplayer/articles/acoustic-echo-cancellation.html
				
				mic.codec = SoundCodec.SPEEX;
				mic.framesPerPacket = 1;
				mic.setSilenceLevel(0, 2000);
				mic.gain = 50.0;

				mic.setUseEchoSuppression(true);

				stream.attachAudio(mic);
			}
			
			stream.publish(connection.nearID);
			
			return true;
		}
	}
}