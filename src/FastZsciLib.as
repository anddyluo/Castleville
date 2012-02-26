//Created by Action Script Viewer - http://www.buraks.com/asv
package {
    import flash.utils.ByteArray;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;

    public class FastZsciLib {

        public function FastZsciLib():void{
        }
        public static function main():void{
        }
		//_arg1:RGB数据
		//_arg2:alpha数据
		//_arg3:图像的宽度
		//_arg4:图像的高度
        public static function decodeAlpha(_arg1:ByteArray, _arg2:ByteArray, _arg3:int, _arg4:int):BitmapData{
            var _local5:int;
            var _local7:int;
            var _local8:int;
            var _local10:int;
            var _local11:flash.utils.ByteArray = new flash.utils.ByteArray();
            var _local12:flash.display.BitmapData = new flash.display.BitmapData(_arg3, _arg4, true);
            var _local13:flash.geom.Rectangle = new flash.geom.Rectangle(0, 0, _arg3, _arg4);
            var _local14:int = _arg2.readInt();//读取32位4字节数据
            var _local9 = (12 + _local14);
            _arg2.position = ((_arg2.readInt() + _local14) + 12);//移动指针
            _arg2.readBytes(_local11, 0, 16);//读取16字节调色板
            var _local15:uint = ((_arg3 * _arg4) >> 2);//总像素数除以4，四像素块的个数
            var _local16:uint;
            var _local17:uint;
            while (_local17 < _local15) {//遍历所有像素块
                _local8++;
                _local5 = ((_arg2[(12 + (_local8 >> 3))] >> (_local8 & 7)) & 1);
                if (_local5 > 0){
                    _local8++;
                    _local5 = ((_arg2[(12 + (_local8 >> 3))] >> (_local8 & 7)) & 1);
                    if (_local5 > 0){
						//将alpha信息插入到RGB数据中
                        _local7 = _arg2[(_local9 + _local10)];
                        _arg1[_local16] = _local11[(_local7 & 15)];
                        _arg1[(_local16 + 4)] = _local11[((_local7 >> 4) & 15)];
						//8个像素共用一个数据块
                        _local10++;
                        _local7 = _arg2[(_local9 + _local10)];
                        _arg1[(_local16 + 8)] = _local11[(_local7 & 15)];
                        _arg1[(_local16 + 12)] = _local11[((_local7 >> 4) & 15)];
                        _local10++;
                    };
                } else {
                    _arg1[_local16] = 0;
                    _arg1[(_local16 + 4)] = 0;
                    _arg1[(_local16 + 8)] = 0;
                    _arg1[(_local16 + 12)] = 0;
                };
                _local16 = (_local16 + 16);
                _local17++;
            };
            var _local18 = ((_arg3 * _arg4) & 3);
            _local10 = (_local10 << 3);
            var _local19:int;
            while (_local19 < _local18) {
                _arg1[_local16] = _local11[((_arg2[(_local9 + (_local10 >> 3))] >> (_local10 & 7)) & 15)];
                _local16 = (_local16 + 4);
                _local10 = (_local10 + 4);
                _local19++;
            };
            _arg1.position = 0;
            _local12.setPixels(_local13, _arg1);
            return (_local12);
        }
    }
}//package 
