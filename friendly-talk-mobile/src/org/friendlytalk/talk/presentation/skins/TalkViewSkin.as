package org.friendlytalk.talk.presentation.skins
{
	import org.friendlytalk.talk.artwork.Background;
	
	import spark.skins.mobile.supportClasses.MobileSkin;
	
	public class TalkViewSkin extends MobileSkin
	{
		public function TalkViewSkin()
		{
			super();
		}
		
		//----------------------------------------------------------------------
		//
		//	Variables
		//
		//----------------------------------------------------------------------
		
		private var background:Background;
		
		//----------------------------------------------------------------------
		//
		//	Overridden methods
		//
		//----------------------------------------------------------------------
		
		/** @private */
		override protected function createChildren():void
		{
			if (!this.background)
			{
				this.background = new Background();
				this.addChild(this.background);
			}
			
			super.createChildren();
		}

		/** @private */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			if (this.background)
			{
				this.background.setLayoutBoundsSize(w, h);
			}
		}
	}
}