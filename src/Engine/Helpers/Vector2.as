//Created by Action Script Viewer - http://www.buraks.com/asv
package Engine.Helpers{
    import flash.geom.Point;

    public class Vector2 extends flash.geom.Point {

        public function Vector2(_arg1:Number=0, _arg2:Number=0){
            super(_arg1, _arg2);
        }
        public static function lerp(_arg1:Vector2, _arg2:Vector2, _arg3:Number):Vector2{
            var _local4:Vector2 = new (Vector2)();
            var _local5:Number = (1 - _arg3);
            _local4.x = ((_arg1.x * _local5) + (_arg2.x * _arg3));
            _local4.y = ((_arg1.y * _local5) + (_arg2.y * _arg3));
            return (_local4);
        }

        public function cloneVec2():Vector2{
            return (new Vector2(x, y));
        }

    }
}//package Engine.Helpers
