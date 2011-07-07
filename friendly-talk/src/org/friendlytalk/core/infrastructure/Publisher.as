package org.friendlytalk.core.infrastructure
{
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.MicrophoneEnhancedOptions;
	import flash.media.SoundCodec;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.Capabilities;
	
	import org.friendlytalk.utils.RuntimeUtil;

	public class Publisher
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
		//	Properties
		//
		//----------------------------------------------------------------------
		
		[Bindable]
		public var camera:Camera;
		
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
			
			if (!this.camera)
				this.camera = Camera.getCamera();
			
			if (this.camera)
			{
				this.camera.setMode(320, 240, 24);
				this.camera.setQuality(0, 50);
				this.camera.setKeyFrameInterval(25);
				
				stream.attachCamera(this.camera);
				
//				code for Flash PLayer 11
//				var settings:H264VideoStreamSettings = new H264VideoStreamSettings();
//				settings.setProfileLevel(H264Profile.BASELINE, H264Level.LEVEL_2);
//				
//				stream.videoStreamSettings = settings;
			}
			
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

				stream.attachAudio(mic);
			}
			
			stream.publish(connection.nearID);
			
			return true;
		}
	}
}