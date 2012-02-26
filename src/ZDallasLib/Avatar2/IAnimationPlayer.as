//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Avatar2{
    public interface IAnimationPlayer {

        function playing():Boolean;
        function reset():void;
        function play(_arg1:Boolean=false, _arg2:Boolean=false):void;
        function stop():void;
        function update(_arg1:Number):Boolean;
        function get position():Number;
        function get isHolding():Boolean;

    }
}//package ZDallasLib.Avatar2
