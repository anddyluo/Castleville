//Created by Action Script Viewer - http://www.buraks.com/asv
package Engine.Classes{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    public class ZSCI {

        private var m_jpegData:flash.utils.ByteArray;
        private var m_alphaData:flash.utils.ByteArray;
        private var m_useFastZsci:Boolean = true;
        private var m_isAlphaDecompressed:Boolean;

        public function ZSCI(_arg1:flash.utils.ByteArray):void{
            this.m_jpegData = new flash.utils.ByteArray();
            this.m_alphaData = new flash.utils.ByteArray();
            super();
            _arg1.position = 12;
            _arg1.endian = flash.utils.Endian.LITTLE_ENDIAN;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            _arg1.readBytes(this.m_jpegData, 0, _local2);
            _arg1.readBytes(this.m_alphaData, 0, _local3);
            this.m_isAlphaDecompressed = false;
        }
        public function getJpegData():flash.utils.ByteArray{
            return (this.m_jpegData);
        }
        public function decompressAlpha():void{
            if (this.m_isAlphaDecompressed == false){
                this.m_isAlphaDecompressed = true;
                this.m_alphaData.uncompress();
                this.m_alphaData.endian = flash.utils.Endian.LITTLE_ENDIAN;
            };
        }
        private function decodeSlow(_arg1:flash.display.Bitmap):flash.display.BitmapData{
            var _local2:int;
            var _local3:int;
            var _local4:int;
            var _local6:int;
            _arg1.blendMode = flash.display.BlendMode.ALPHA;
            var _local5:int;
            var _local7:int;
            var _local8:flash.utils.ByteArray = new flash.utils.ByteArray();
            var _local9:flash.display.BitmapData = new flash.display.BitmapData(_arg1.width, _arg1.height, true);
            var _local10:flash.geom.Rectangle = new flash.geom.Rectangle(0, 0, _arg1.width, _arg1.height);
            var _local11:flash.utils.ByteArray = _arg1.bitmapData.getPixels(_local10);
            this.decompressAlpha();
            var _local12:int = this.m_alphaData.readInt();
            _local6 = (12 + _local12);
			//移动文件指针，位于字节数组第一个int+12的位置
            this.m_alphaData.position = ((this.m_alphaData.readInt() + _local12) + 12);
            this.m_alphaData.readBytes(_local8, 0, 16);
            var _local13 = ((_arg1.width * _arg1.height) >> 2);//所有像素点/4
            var _local14:uint;
            var _local15:uint;
            while (_local15 < _local13) {
                var _temp1 = this.m_alphaData[(12 + (_local5 >> 3))];//每个8像素块公用一坨数据
                var _temp2 = _local5;
                _local5 = (_local5 + 1);
                _local2 = ((_temp1 >> (_temp2 & 7)) & 1);
                if (_local2){
                    var _temp3 = this.m_alphaData[(12 + (_local5 >> 3))];
                    var _temp4 = _local5;
                    _local5 = (_local5 + 1);
                    _local2 = ((_temp3 >> (_temp4 & 7)) & 1);
                    if (_local2){
                        _local4 = this.m_alphaData[(_local6 + _local7)];
                        _local11[_local14] = _local8[(_local4 & 15)];
                        _local11[(_local14 + 4)] = _local8[((_local4 >> 4) & 15)];
                        _local7++;
                        _local4 = this.m_alphaData[(_local6 + _local7)];
                        _local11[(_local14 + 8)] = _local8[(_local4 & 15)];
                        _local11[(_local14 + 12)] = _local8[((_local4 >> 4) & 15)];
                        _local7++;
                    };
                } else {
                    _local11[_local14] = 0;
                    _local11[(_local14 + 4)] = 0;
                    _local11[(_local14 + 8)] = 0;
                    _local11[(_local14 + 12)] = 0;
                };
                _local14 = (_local14 + 16);//以16位为单位读取
                _local15++;
            };
            var _local16 = ((_arg1.width * _arg1.height) & 3);
            _local7 = (_local7 << 3);
            var _local17:int;
            while (_local17 < _local16) {
                _local11[_local14] = _local8[((this.m_alphaData[(_local6 + (_local7 >> 3))] >> (_local7 & 7)) & 15)];
                _local14 = (_local14 + 4);
                _local7 = (_local7 + 4);
                _local17++;
            };
            _local11.position = 0;
            _local9.setPixels(_local10, _local11);
            return (_local9);
        }
        private function decodeFast(_arg1:flash.display.Bitmap):flash.display.BitmapData{
            var _local2:flash.geom.Rectangle = new flash.geom.Rectangle(0, 0, _arg1.width, _arg1.height);
            var _local3:flash.utils.ByteArray = _arg1.bitmapData.getPixels(_local2);
            this.decompressAlpha();
            return (FastZsciLib.decodeAlpha(_local3, this.m_alphaData, _arg1.width, _arg1.height));
        }
        public function decodeAlpha(_arg1:flash.display.Bitmap):flash.display.BitmapData{
            if (this.m_useFastZsci){
                return (this.decodeFast(_arg1));
            };
            return (this.decodeSlow(_arg1));
        }

    }
}//package Engine.Classes
