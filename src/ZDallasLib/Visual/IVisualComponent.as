//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Visual{
    import flash.display.DisplayObject;

    public interface IVisualComponent {

        function getDisplayObject():flash.display.DisplayObject;
        function getInstance():IVisualComponent;
        function update(_arg1:Number):Boolean;
        function get isAnimating():Boolean;
        function get isDirty():Boolean;
        function get flipped():Boolean;
        function set flipped(_arg1:Boolean):void;
        function get owner():Object;
        function set owner(_arg1:Object):void;
        function get name():String;
        function set name(_arg1:String):void;
        function loadFromXML(_arg1:XML):void;
        function loadAssets(_arg1:uint=15):void;
        function get isLoaded():Boolean;
        function get isLoading():Boolean;

    }
}//package ZDallasLib.Visual
