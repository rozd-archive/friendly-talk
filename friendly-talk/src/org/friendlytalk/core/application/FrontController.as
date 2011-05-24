package org.friendlytalk.core.application
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	import flash.media.Microphone;
	import flash.media.MicrophoneEnhancedOptions;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.Capabilities;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.IList;
	
	import org.friendlytalk.core.domain.Broadcaster;
	import org.friendlytalk.core.domain.Room;
	import org.friendlytalk.core.infrastructure.Connector;
	import org.friendlytalk.home.events.ConnectEvent;

	public class FrontController
	{
		public function FrontController()
		{
		}
		
		//----------------------------------------------------------------------
		//
		//	Variables
		//
		//----------------------------------------------------------------------
		
		public var connector:Connector;
		
		//----------------------------------------------------------------------
		//
		//	Properties
		//
		//----------------------------------------------------------------------
		
		[Bindable]
		public var room:Room;
		
		//----------------------------------------------------------------------
		//
		//	Commands
		//
		//----------------------------------------------------------------------
		
		public function connect(event:ConnectEvent):void
		{
			if (!this.room) return;
			
			this.room.connecting = true;
			
			this.connector.addEventListener(ErrorEvent.ERROR, errorHandler);
			this.connector.addEventListener(Event.CONNECT, connectHandler);
			this.connector.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			
			this.connector.connect(event.room);
		}
		
		public function publish():void
		{
			if (!this.room || !this.room.connected) return;
			
			var connection:NetConnection = this.connector.getNetConnection();
			var stream:NetStream = this.connector.getBroadcastNetStream()
			
			if (!connection || !stream) return;
			
			var cam:Camera = Camera.getCamera();
			
			if (cam)
			{
				cam.setMode(320, 240, 24);
				cam.setQuality(0, 50);
				cam.setKeyFrameInterval(25);
				
				stream.attachCamera(cam);
				
				var settings:H264VideoStreamSettings = new H264VideoStreamSettings();
				settings.setProfileLevel(H264Profile.BASELINE, H264Level.LEVEL_2);
				
				stream.videoStreamSettings = settings;
			}
			
			var mic:Microphone = 
				"getEnhancedMicrophone" in Microphone ? 
				Microphone["getEnhancedMicrophone"]() as Microphone : 
				Microphone.getMicrophone();
			
			if (mic)
			{
				if ("enhancedOptions" in mic)
				{
					try
					{
						var Type:Class = 
							getDefinitionByName("flash.media::MicrophoneEnhancedOptions") as Class;
						
						var options:Object = new Type();
						options["mode"] = "fullDuplex";
						options["autoGain"] = true;
						
						mic["enhancedOptions"] = options;
						
					}
					catch (error:Error)
					{
						
					}
					
				}
				else
				{
					mic.setUseEchoSuppression(true);
				}
				
				
				stream.attachAudio(mic);
			}
			
			stream.publish(connection.nearID);
		}
		
		private function subscribe(name:String):void
		{
			if (!this.room || !this.room.broadcasters) return;
			
			var n:uint = this.room.broadcasters.length;
			for (var i:uint = 0; i < n; i++)
			{
				var p:Broadcaster = 
					this.room.broadcasters.getItemAt(i) as Broadcaster;
				
				if (p.name == name)
					return;
			}
			
			var stream:NetStream = this.connector.getSubscribeNetStream();
			
			trace(stream.videoStreamSettings.codec);
			
			var broadcaster:Broadcaster = new Broadcaster();
			broadcaster.name = name;
			broadcaster.stream = stream;
			broadcaster.stream.play(name);
			
			this.room.broadcasters.addItem(broadcaster);
		}

		private function unsubscribe(name:String):void
		{
			if (!this.room || !this.room.broadcasters) return;
			
			var n:uint = this.room.broadcasters.length;
			for (var i:uint = 0; i < n; i++)
			{
				var b:Broadcaster = this.room.broadcasters.getItemAt(i) as Broadcaster;
				
				if (b && b.name == name)
				{
					b.stream.close();
					
					this.room.broadcasters.removeItemAt(i);
					
					return;
				}
			}
		}
		
		//----------------------------------------------------------------------
		//
		//	Handlers
		//
		//----------------------------------------------------------------------
		
		private function errorHandler(event:ErrorEvent):void
		{
			if (!this.room) return;
			
			this.room.connected = false;
			this.room.connecting = false;
		}
		
		
		private function connectHandler(event:Event):void
		{
			if (!this.room) return;
			
			this.room.connected = true;
			this.room.connecting = false;
			
			this.publish();
		}
		
		private function netStatusHandler(event:NetStatusEvent):void
		{
			switch (event.info.code)
			{
				// NetGroup
				
				case "NetGroup.MulticastStream.PublishNotify": // e.info.group
					
					this.subscribe(event.info.name);
					
					break;
				
				case "NetGroup.MulticastStream.UnpublishNotify": // e.info.group
					
					this.unsubscribe(event.info.name);
					
					break;
			}
			
		}
	}
}