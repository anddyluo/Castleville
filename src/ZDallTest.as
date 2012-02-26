package
{
	import ZDallasLib.Visual.AnimatedPuppet;
	
	import flash.display.Sprite;
	
	public class ZDallTest extends Sprite
	{
		public function ZDallTest()
		{
			var _local3:flash.display.DisplayObject;
			var _local5:AnimatedPuppet;
			_local5 = new AnimatedPuppet();
			_local5.name = "Cow_03";
			_local5.loadFromXML(new XML('<visual archetype="assets/Cow_03.arc" skin="assets/Cow_03.asc" defaultAnimation="idle_01" forceZsciSpriteSheet="false"/>'));
			_local5.loadAssets(15);
			
			var _local2:ZDallasLib.Visual.IVisualComponent = _local5;
			_local3 = _local2.getInstance().getDisplayObject();
			_local3.x= 100;
			_local3.y=200;
			this.addChild(_local3);
		}
	}
}