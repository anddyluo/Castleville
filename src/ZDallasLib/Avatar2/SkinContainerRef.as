//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Avatar2{
    import flash.display.BitmapData;
    import __AS3__.vec.Vector;
    import flash.geom.Matrix3D;
    import __AS3__.vec.*;

    public class SkinContainerRef {

        public var jointID:int = -1;
        public var sequenceAttributeID:int = -1;
        public var sortValue:Number = 0;
        public var currentBitmap:flash.display.BitmapData;
        public var scaleContainer:Boolean = false;
        public var debugDrawColor:uint = 0;
        public var debugDrawAlpha:Number = 0.5;
        public var isVisible:Boolean = true;
        public var skinContainer:SkinContainer;
        public var mat3D:Vector.<Matrix3D>;
        public var currentMat3D:flash.geom.Matrix3D;
        private var m_tintedBitmaps:Vector.<BitmapData>;
        private var m_dirty:Vector.<Boolean>;
        private var m_colors:Array;
        private var m_isTinted:Boolean = false;

        public function SkinContainerRef(_arg1:SkinContainer){
            this.currentMat3D = new flash.geom.Matrix3D();
            this.m_colors = [0xFFFFFF, 0xFFFFFF, 0xFFFFFF];
            super();
            var _local2:uint = _arg1.m_bitmapData.length;
            this.skinContainer = _arg1;
            this.m_tintedBitmaps = new Vector.<flash.display.BitmapData>(_local2, true);
            this.m_dirty = new Vector.<Boolean>(_local2, true);
            var _local3:uint;
            while (_local3 < _local2) {
                this.m_dirty[_local3] = true;
                _local3++;
            };
            this.mat3D = new Vector.<flash.geom.Matrix3D>(_local2, true);
        }
        public function setColor(_arg1:uint, _arg2:uint):void{
            if (_arg1 < this.m_colors.length){
                this.m_colors[_arg1] = _arg2;
                this.m_isTinted = ((((!((this.m_colors[0] == 0xFFFFFF))) || (!((this.m_colors[1] == 0xFFFFFF))))) || (!((this.m_colors[2] == 0xFFFFFF))));
                this.resetBitmaps();
            };
        }
        public function getBitmapData(_arg1:uint):flash.display.BitmapData{
            var _local2:flash.display.BitmapData;
            if ((((_arg1 < this.skinContainer.m_bitmapData.length)) && (this.skinContainer.m_bitmapData[_arg1]))){
                if (((((this.m_isTinted) && (this.skinContainer.m_bitmapData[_arg1]))) && (this.skinContainer.m_colorMaskBitmapData[_arg1]))){
                    _local2 = this.m_tintedBitmaps[_arg1];
                    if (_local2 == null){
                        _local2 = this.skinContainer.getTintedBitmapData(_arg1, this.m_colors[0], this.m_colors[1], this.m_colors[2]);
                        this.m_tintedBitmaps[_arg1] = _local2;
                    } else {
                        if (this.m_dirty[_arg1]){
                            this.skinContainer.getTintedBitmapData(_arg1, this.m_colors[0], this.m_colors[1], this.m_colors[2], _local2);
                            this.m_dirty[_arg1] = false;
                        };
                    };
                } else {
                    _local2 = this.skinContainer.m_bitmapData[_arg1];
                };
            };
            return (_local2);
        }
        public function resetBitmaps():void{
            var _local1:uint = this.m_tintedBitmaps.length;
            var _local2:uint;
            while (_local2 < _local1) {
                this.m_dirty[_local2] = true;
                _local2++;
            };
            if (!this.m_isTinted){
                this.releaseBitmaps();
            };
        }
        public function releaseBitmaps():void{
            var _local3:flash.display.BitmapData;
            var _local1:uint = this.m_tintedBitmaps.length;
            var _local2:uint;
            while (_local2 < _local1) {
                _local3 = this.m_tintedBitmaps[_local2];
                if (((_local3) && (!((_local3 == this.skinContainer.m_bitmapData[_local2]))))){
                    this.m_tintedBitmaps[_local2].dispose();
                };
                this.m_tintedBitmaps[_local2] = null;
                _local2++;
            };
        }

    }
}//package ZDallasLib.Avatar2
