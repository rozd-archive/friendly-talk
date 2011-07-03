package org.friendlytalk.core.presentation.renderers
{
	import flash.media.Sound;
	import flash.net.NetStream;
	
	import mx.core.IDataRenderer;
	import mx.core.IFlexDisplayObject;
	import mx.core.ILayoutElement;
	import mx.core.UIComponent;
	
	import org.friendlytalk.core.domain.Broadcaster;
	import org.friendlytalk.core.presentation.components.VideoDisplay;
	
	import spark.components.IItemRenderer;
	import spark.components.Label;
	
	public class BroadcastRenderer extends UIComponent implements IItemRenderer
	{
		public function BroadcastRenderer()
		{
			super();
		}
		
		//----------------------------------------------------------------------
		//
		//	Variables
		//
		//----------------------------------------------------------------------
		
		private var videoDisplay:VideoDisplay;
		
		//----------------------------------------------------------------------
		//
		//	Properties: IItemRenderer
		//
		//----------------------------------------------------------------------
		
		private var dataChanged:Boolean = false;
		
		private var _data:Object;
		
		public function get data():Object
		{
			return this._data;
		}
		
		public function set data(value:Object):void
		{
			if (value == this._data)
				return;
			
			this._data = value;
			
			this.dataChanged = true;
			
			this.invalidateProperties();
		}

		public function get dragging():Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
		public function set dragging(value:Boolean):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get itemIndex():int
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function set itemIndex(value:int):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get label():String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function set label(value:String):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get selected():Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
		public function set selected(value:Boolean):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get showsCaret():Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
		public function set showsCaret(value:Boolean):void
		{
			// TODO Auto Generated method stub
			
		}
		
		//----------------------------------------------------------------------
		//
		//	Overridden methods: UIComponent
		//
		//----------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			if (!this.videoDisplay)
			{
				this.videoDisplay = new VideoDisplay();
				this.addChild(this.videoDisplay);
			}
		}
		
		//----------------------------------------------------------------------
		//
		//	Overridden methods: UIComponent
		//
		//----------------------------------------------------------------------
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (this.dataChanged)
			{
				if (this.data is Broadcaster)
				{
					var stream:NetStream = Broadcaster(this.data).stream;
					
					if (this.videoDisplay)
						this.videoDisplay.source = stream;
				
					stream.play(Broadcaster(this.data).name);
				}
				
				this.dataChanged = false;
			}
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
//			trace(w, h);
			
			this.graphics.clear();
			this.graphics.beginFill(0xFF0000);
			this.graphics.drawRect(0, 0, w, h);
			this.graphics.endFill();
			
			if (!this.videoDisplay)
				return;
			
			var paddingLeft:uint	= this.getStyle("paddingLeft"); 
			var paddingRight:uint	= this.getStyle("paddingRight");
			var paddingTop:uint		= this.getStyle("paddingTop");
			var paddingBottom:uint	= this.getStyle("paddingBottom");
			
			var viewWidth:Number  = w - paddingLeft - paddingRight;
			var viewHeight:Number = h - paddingTop  - paddingBottom;
			
			this.setElementPosition(this.videoDisplay, paddingLeft, paddingTop);
			this.setElementSize(this.videoDisplay, viewWidth, viewHeight);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: Layout Helpers
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @copy spark.skins.mobile.supportClasses.MobileSkin#setElementPosition()
		 *
		 *  @see #setElementSize  
		 * 
		 *  @langversion 3.0
		 *  @playerversion AIR 2.5 
		 *  @productversion Flex 4.5
		 */
		protected function setElementPosition(element:Object, x:Number, y:Number):void
		{
			if (element is ILayoutElement)
			{
				ILayoutElement(element).setLayoutBoundsPosition(x, y, false);
			}
			else if (element is IFlexDisplayObject)
			{
				IFlexDisplayObject(element).move(x, y);   
			}
			else
			{
				element.x = x;
				element.y = y;
			}
		}
		
		/**
		 *  @copy spark.skins.mobile.supportClasses.MobileSkin#setElementSize()
		 *
		 *  @see #setElementPosition  
		 * 
		 *  @langversion 3.0
		 *  @playerversion AIR 2.5 
		 *  @productversion Flex 4.5
		 */
		protected function setElementSize(element:Object, width:Number, height:Number):void
		{
			if (element is ILayoutElement)
			{
				ILayoutElement(element).setLayoutBoundsSize(width, height, false);
			}
			else if (element is IFlexDisplayObject)
			{
				IFlexDisplayObject(element).setActualSize(width, height);
			}
			else
			{
				element.width = width;
				element.height = height;
			}
		}
		
	}
}