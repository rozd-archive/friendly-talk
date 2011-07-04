package org.friendlytalk.core.presentation.components
{
	import flash.display.Sprite;
	import flash.media.Video;
	import flash.net.NetStream;
	
	import mx.core.UIComponent;
	import mx.utils.NameUtil;
	
	import spark.core.SpriteVisualElement;
	
	[Style(name="horizontalAlign", inherit="no", type="String", enumeration="center,left,right")]

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
		
		private var _scaleMode:String = VideoDisplayScaleMode.LETTERBOX;

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
//			if (!this.video) return;
			
			var wRatio:uint = 4;
			var hRatio:uint = 3;
			
			var ratio:Number = wRatio / hRatio;
			
			var x:int;
			var y:int;
			var w:uint;
			var h:uint;
			
			var horizontalAlign:String = getStyle("horizontalAlign");
			var verticalAlign:String = getStyle("verticalAlign");
			
			horizontalAlign = null;
			verticalAlign = null;
			
			var hAlign:Number;
			if (horizontalAlign == "left")
				hAlign = 0.0;
			else if (horizontalAlign == "right")
				hAlign = 1.0;
			else // if (horizontalAlign == "center")
				hAlign = 0.5;

			var vAlign:Number;
			if (verticalAlign == "top")
				vAlign = 0.0;
			else if (verticalAlign == "bottom")
				vAlign = 1.0;
			else // if (verticalAlign == "middle")
				vAlign = 0.5;
			
			switch (this.scaleMode)
			{
				case VideoDisplayScaleMode.LETTERBOX :
				{
					if (width / height > wRatio / hRatio)
					{
						// horizontal
						
						w = ratio * height;
						h = height;
						x = (width - w) * hAlign;
						y = 0;
					}
					else
					{
						// vertical
						
						w = width;
						h = width / ratio;
						x = 0;
						y = (height - h) * vAlign;
					}
				}
			}
			
			this.graphics.clear();
			this.graphics.beginFill(0xFF0099);
			this.graphics.drawRect(x, y, w, h);
			this.graphics.endFill();
			
			this.video.x = x;
			this.video.y = y;
			this.video.width = w;
			this.video.height = h;
		}
	}
}