package org.friendlytalk.core.infrastructure
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.net.NetStream;
	
	[Event(name="netStatus", type="flash.events.NetStatusEvent")]
	
	[Event(name="error", type="flash.events.ErrorEvent")]
	
	[Event(name="connect", type="flash.events.Event")]
	
	public class Connector extends EventDispatcher
	{
		//----------------------------------------------------------------------
		//
		//	Class constnats
		//
		//----------------------------------------------------------------------
		
		private static const SERVER_URL:String = "rtmfp://p2p.rtmfp.net/4eac03fdddf60bb5e7df9cb3-c21addd5ccab/";

		private static const DEFAULT_SPACE:String = "public";
		
		private static const DEFAULT_ROOM:String = "public-room";
		
		//----------------------------------------------------------------------
		//
		//	Constructor
		//
		//----------------------------------------------------------------------
		
		public function Connector(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		//----------------------------------------------------------------------
		//
		//	Variables
		//
		//----------------------------------------------------------------------
		
		private var connection:NetConnection;
		
		private var group:NetGroup;
		
		private var stream:NetStream;
		
		private var specifire:GroupSpecifier;
		
		private var connected:Boolean;
		
		private var room:String;
		
		//----------------------------------------------------------------------
		//
		//	Properties
		//
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//
		//	Methods
		//
		//----------------------------------------------------------------------
		
		//-----------------------------------
		//	Methods: Public API
		//-----------------------------------
		
		public function connect(room:String=null):void
		{
			this.room = room || DEFAULT_ROOM;
			
			this.doConnect();
		}
		
		public function disconnect():void
		{
			if (this.connection)
			{
				this.connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				this.connection.close();
			}
			
			if (this.group)
			{
				this.group.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				this.group.close();
			}
			
			if (this.stream)
			{
				this.stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				this.stream.close();
			}
			
			this.connected = false;
		}
		
		public function getSubscribeNetStream():NetStream
		{
			return new NetStream(this.connection, this.specifire.groupspecWithAuthorizations());
		}
		
		public function getNetConnection():NetConnection
		{
			return this.connection;
		}

		public function getBroadcastNetStream():NetStream
		{
			return this.stream;
		}
		
		//-----------------------------------
		//	Methods: connection
		//-----------------------------------

		private function doConnect():void
		{
			if (this.connection && this.connection.connected)
				return;
			
			this.connection = new NetConnection();
			this.connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			this.connection.connect(SERVER_URL);
			
			this.connected = true;
		}
		
		private function onConnected():void
		{
			this.specifire = new GroupSpecifier(this.room);
			
			this.specifire.multicastEnabled = true;
			this.specifire.postingEnabled = true;
			this.specifire.serverChannelEnabled = true;
			
			this.doGroupConnect();
		}

		//-----------------------------------
		//	Methods: group
		//-----------------------------------

		private function doGroupConnect():void
		{
			this.group = new NetGroup(this.connection, this.specifire.groupspecWithAuthorizations());
			this.group.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
		}
		
		private function onGroupConnected():void
		{
			this.doStreamConnect();
		}
		
		//-----------------------------------
		//	Methods: stream
		//-----------------------------------

		private function doStreamConnect():void
		{
			this.stream = new NetStream(this.connection, this.specifire.groupspecWithAuthorizations());
			this.stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
		}
		
		private function onStreamConnected():void
		{
			this.dispatchEvent(new Event(Event.CONNECT));
		}
		
		//----------------------------------------------------------------------
		//
		//	Handlers
		//
		//----------------------------------------------------------------------
		
		private function netStatusHandler(event:NetStatusEvent):void
		{
			trace(event.info.code);
			switch (event.info.code)
			{
				// NetConnection
				
				case "NetConnection.Connect.Success" :
					
					this.onConnected()
					
					break;
				
				case "NetConnection.Connect.Closed":
				case "NetConnection.Connect.Failed":
				case "NetConnection.Connect.Rejected":
				case "NetConnection.Connect.AppShutdown":
				case "NetConnection.Connect.InvalidApp":
				
					this.disconnect();
					this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
					
					break;
					
				// NetGroup
					
				case "NetGroup.Connect.Success": // e.info.group
					
					this.onGroupConnected();
					
					break;
				
				case "NetGroup.Connect.Rejected": // e.info.group
				case "NetGroup.Connect.Failed": // e.info.group
					
					this.disconnect();
					this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
					
					break;
				
				// NetStrem
				
				case "NetStream.Connect.Success": // e.info.stream
					
					this.onStreamConnected();
					
					break;
				
				case "NetStream.Connect.Rejected": // e.info.stream
				case "NetStream.Connect.Failed": // e.info.stream
					
					this.disconnect();
					this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
					
					break;
			}
			
			if (this.hasEventListener(event.type))
			{
				this.dispatchEvent(event.clone());
			}
		}
	}
}