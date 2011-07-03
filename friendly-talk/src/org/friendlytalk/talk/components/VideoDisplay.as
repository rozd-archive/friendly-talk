package org.friendlytalk.talk.components
{
	import flash.display.Sprite;
	import flash.media.Video;
	import flash.net.NetStream;
	
	import mx.core.UIComponent;
	import mx.utils.NameUtil;
	
	import spark.core.SpriteVisualElement;
	
	[Style(name="horizontalAlign", inherit="no", type="String", enumeration="left,center,right")]

	[Style(name="verticalAlign", inherit="no", type="String", enumeration="top,middle,bottom")]
	
	public class VideoDisplay extends UIComponent
	{
		public function VideoDisplay()
		{
			super();
		}
		
		//----------------------------------------------------------------------
		//
		//	Variables
		//	
		//----------------------------------------------------------------------
		
		private var oldWidth:Number;
		
		private var oldHeight:Number;
		
		private var video:Video;
		
		private var ratioW:Number;
		
		private var ratioH:Number;
		
		//----------------------------------------------------------------------
		//
		//	Properties
		//	
		//----------------------------------------------------------------------
		
		//-----------------------------------
		//	source
		//-----------------------------------
		
		private var sourceChanged:Boolean = false;
		
		private var _source:Object;

		[Bindable]
		public function get source():Object
		{
			return _source;
		}

		public function set source(value:Object):void
		{
			this._source = value;
			
			this.sourceChanged = true;
			this.invalidateDisplayList();
		}
		
		//-----------------------------------
		//	aspectRatio
		//-----------------------------------
		
		private var _aspectRatio:String = "4:3";

		public function get aspectRatio():String
		{
			return _aspectRatio;
		}

		public function set aspectRatio(value:String):void
		{
			_aspectRatio = value;
		}
		
		//-----------------------------------
		//	aspectRatio
		//-----------------------------------
		
		private var _scaleMode:String

		public function get scaleMode():String
		{
			return _scaleMode;
		}

		public function set scaleMode(value:String):void
		{
			_scaleMode = value;
		}
		
		//----------------------------------------------------------------------
		//
		//	Overridden methods
		//	
		//----------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			super.createChildren();
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			if (this.sourceChanged)
			{
				this.cleanVideo();
				this.setupVideo();
				
				this.sourceChanged = false;
			}
			
			if (w != this.oldWidth || h != this.oldHeight)
			{
				this.adjustVideo(w, h);
			}
			
			this.oldWidth = w;
			this.oldHeight = h;
		}
		
		//----------------------------------------------------------------------
		//
		//	Methods
		//	
		//----------------------------------------------------------------------
		
		private function cleanVideo():void
		{
			if (this.video)
			{
				this.video.attachNetStream(null);
				this.video.clear();
			}
		}
		
		private function setupVideo():void
		{
			if (!this.source)
			{
				if (this.video)
				{
					this.removeChild(this.video);
					this.video = null;
				}
			}
			else
			{
				if (!this.video)
				{
					this.video = new Video();
					this.addChild(this.video);
				}
					
				this.video.attachNetStream(this.source as NetStream);
			}
		}
		
		private function adjustVideo(width:Number, height:Number):void
		{
			var wRatio:uint = 4;
			var hRatio:uint = 3;
			
			var ratio:Number = wRatio / hRatio;
			
			var x:int;
			var y:int;
			var w:uint;
			var h:uint;
			
			var hAlign:String = this.getStyle("horizontalAlign") || "center";
			var vAlign:String = this.getStyle("verticalAlign") || "middle";
			
			switch (this.scaleMode)
			{
				case VideoDisplayScaleMode.LETTERBOX :
				{
					if (width / height > wRatio / hRatio)
					{
						// horizontal
						
						w = ratio * height;
						h = height;
						y = 0;
						
						if (hAlign == "center") 
							x = width / 2 - w / 2;
						else if (hAlign == "left")
							x = 0;
						else if (hAlign == "right")
							x = width - w;
					}
					else
					{
						// vertical
						
						w = width;
						h = width / ratio;
						x = 0;
						
						if (hAlign == "middle") 
							y = height / 2 - h / 2;
						else if (hAlign == "top")
							y = 0;
						else if (hAlign == "bottom")
							y = height - h;
					}
				}
			}
			
			this.video.x = x;
			this.video.y = y;
			this.video.width = w;
			this.video.height = h;
		}
	}
}