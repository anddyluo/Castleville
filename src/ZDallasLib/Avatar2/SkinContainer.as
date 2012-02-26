//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Avatar2{
    import flash.geom.Point;
    import flash.filters.ColorMatrixFilter;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.geom.Matrix3D;
    import flash.display.BitmapDataChannel;
    import flash.display.BlendMode;
    import __AS3__.vec.*;
	import __AS3__.vec.Vector;

    public class SkinContainer {

        public static const IMAGE_FRONT:uint = 0;
        public static const IMAGE_BACK:uint = 1;
        public static const NUM_IMAGE_ORIENTATIONS:uint = 2;
        private static const m_zeroPoint:flash.geom.Point = new flash.geom.Point(0, 0);

        private static var m_colorFilter:flash.filters.ColorMatrixFilter = new flash.filters.ColorMatrixFilter([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);

        public var m_name:String = "";
        public var m_imageName:Vector.<String>;
        public var m_colorMaskImageName:Vector.<String>;
        public var m_jointName:String;
        public var m_sequenceAttributeName:String;
        public var m_bitmapData:Vector.<BitmapData>;
        public var m_colorMaskBitmapData:Vector.<BitmapData>;
        public var m_tmpColorMaskBitmapData:Vector.<BitmapData>;
        public var m_cropSourceRect:Vector.<Rectangle>;
        public var m_width:Number = 0;
        public var m_height:Number = 0;
        public var m_Mat3D:flash.geom.Matrix3D;

        public function SkinContainer(){
            this.m_imageName = new Vector.<String>();
            this.m_colorMaskImageName = new Vector.<String>();
            this.m_bitmapData = new Vector.<flash.display.BitmapData>();
            this.m_colorMaskBitmapData = new Vector.<flash.display.BitmapData>();
            this.m_tmpColorMaskBitmapData = new Vector.<flash.display.BitmapData>();
            this.m_cropSourceRect = new Vector.<flash.geom.Rectangle>();
            this.m_Mat3D = new flash.geom.Matrix3D();
            super();
        }
        public function getTintedBitmapData(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint, _arg5:flash.display.BitmapData=null):flash.display.BitmapData{
            var _local8:Array;
            var _local9:Number;
            var _local10:flash.display.BitmapData;
            var _local6:flash.display.BitmapData = this.m_bitmapData[_arg1];
            var _local7:flash.display.BitmapData = this.m_colorMaskBitmapData[_arg1];
            if (_local6){
                if (_local7){
                    _local8 = m_colorFilter.matrix;
                    _local9 = (1 / 0xFF);
                    _local8[0] = (((_arg2 >>> 16) & 0xFF) * _local9);
                    _local8[1] = (((_arg3 >>> 16) & 0xFF) * _local9);
                    _local8[2] = (((_arg4 >>> 16) & 0xFF) * _local9);
                    _local8[5] = (((_arg2 >>> 8) & 0xFF) * _local9);
                    _local8[6] = (((_arg3 >>> 8) & 0xFF) * _local9);
                    _local8[7] = (((_arg4 >>> 8) & 0xFF) * _local9);
                    _local8[10] = ((_arg2 & 0xFF) * _local9);
                    _local8[11] = ((_arg3 & 0xFF) * _local9);
                    _local8[12] = ((_arg4 & 0xFF) * _local9);
                    m_colorFilter.matrix = _local8;
                    if (_arg5){
                        _arg5.lock();
                        _arg5.copyPixels(_local6, _local6.rect, m_zeroPoint);
                    } else {
                        _arg5 = _local6.clone();
                    };
                    _local10 = this.m_tmpColorMaskBitmapData[_arg1];
                    this.m_tmpColorMaskBitmapData[_arg1].fillRect(_local10.rect, 0xFFFFFFFF);
                    _arg5.copyChannel(_local10, _local10.rect, m_zeroPoint, flash.display.BitmapDataChannel.ALPHA, flash.display.BitmapDataChannel.ALPHA);
                    _local10.applyFilter(_local7, _local7.rect, m_zeroPoint, m_colorFilter);
                    _arg5.draw(_local10, null, null, flash.display.BlendMode.OVERLAY);
                    _arg5.copyChannel(_local6, _local6.rect, m_zeroPoint, flash.display.BitmapDataChannel.ALPHA, flash.display.BitmapDataChannel.ALPHA);
                    _arg5.unlock();
                } else {
                    if (_arg5){
                        _arg5.copyPixels(_local6, _local6.rect, m_zeroPoint);
                    } else {
                        _arg5 = _local6.clone();
                    };
                };
            };
            return (_arg5);
        }

    }
}//package ZDallasLib.Avatar2
