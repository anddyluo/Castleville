//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Avatar2{
    import flash.geom.Vector3D;

    public class JointAnimData {

        public static const CHANNEL_ROTATION_X:uint = 0;
        public static const CHANNEL_ROTATION_Y:uint = 1;
        public static const CHANNEL_ROTATION_Z:uint = 2;
        public static const CHANNEL_ROTATION_W:uint = 3;
        public static const CHANNEL_POSITION_X:uint = 4;
        public static const CHANNEL_POSITION_Y:uint = 5;
        public static const CHANNEL_POSITION_Z:uint = 6;
        public static const CHANNEL_VISIBLE:uint = 7;
        public static const NUM_CHANNELS:uint = 8;

        public var visible:Boolean = true;
        public var flip:Boolean = false;
        public var positionX:Number;
        public var positionY:Number;
        public var positionZ:Number;
        public var rotationX:Number;
        public var rotationY:Number;
        public var rotationZ:Number;
        public var rotationW:Number;

        public function cloneRotation():flash.geom.Vector3D{
            return (new flash.geom.Vector3D(this.rotationX, this.rotationY, this.rotationZ, this.rotationW));
        }
        public function clonePosition():flash.geom.Vector3D{
            return (new flash.geom.Vector3D(this.positionX, this.positionY, this.positionZ));
        }
        public function copy(_arg1:JointAnimData):void{
            this.visible = _arg1.visible;
            this.flip = _arg1.flip;
            this.positionX = _arg1.positionX;
            this.positionY = _arg1.positionY;
            this.positionZ = _arg1.positionZ;
            this.rotationX = _arg1.rotationX;
            this.rotationY = _arg1.rotationY;
            this.rotationZ = _arg1.rotationZ;
            this.rotationW = _arg1.rotationW;
        }
        public function interp(_arg1:Number, _arg2:JointAnimData, _arg3:JointAnimData):void{
            this.visible = _arg2.visible;
            this.flip = _arg2.flip;
            this.positionX = (_arg2.positionX + (_arg1 * (_arg3.positionX - _arg2.positionX)));
            this.positionY = (_arg2.positionY + (_arg1 * (_arg3.positionY - _arg2.positionY)));
            this.positionZ = (_arg2.positionZ + (_arg1 * (_arg3.positionZ - _arg2.positionZ)));
            var _local4:Number = (1 - _arg1);
            var _local5:Number = _arg2.rotationX;
            var _local6:Number = _arg2.rotationY;
            var _local7:Number = _arg2.rotationZ;
            var _local8:Number = _arg2.rotationW;
            var _local9:Number = _arg3.rotationX;
            var _local10:Number = _arg3.rotationY;
            var _local11:Number = _arg3.rotationZ;
            var _local12:Number = _arg3.rotationW;
            if (((((_local5 * _local9) + (_local6 * _local10)) + (_local7 * _local11)) + (_local8 * _local12)) < 0){
                _local4 = (_local4 * -1);
            };
            var _local13:Number = ((_local4 * _local5) + (_arg1 * _local9));
            var _local14:Number = ((_local4 * _local6) + (_arg1 * _local10));
            var _local15:Number = ((_local4 * _local7) + (_arg1 * _local11));
            var _local16:Number = ((_local4 * _local8) + (_arg1 * _local12));
            var _local17:Number = Math.sqrt(((((_local13 * _local13) + (_local14 * _local14)) + (_local15 * _local15)) + (_local16 * _local16)));
            var _local18:Number = (1 / _local17);
            this.rotationX = (_local13 * _local18);
            this.rotationY = (_local14 * _local18);
            this.rotationZ = (_local15 * _local18);
            this.rotationW = (_local16 * _local18);
        }
        public function getChannelData(_arg1:uint):Number{
            switch (_arg1){
                case CHANNEL_ROTATION_X:
                    return (this.rotationX);
                case CHANNEL_ROTATION_Y:
                    return (this.rotationY);
                case CHANNEL_ROTATION_Z:
                    return (this.rotationZ);
                case CHANNEL_ROTATION_W:
                    return (this.rotationW);
                case CHANNEL_POSITION_X:
                    return (this.positionX);
                case CHANNEL_POSITION_Y:
                    return (this.positionY);
                case CHANNEL_POSITION_Z:
                    return (this.positionZ);
                case CHANNEL_VISIBLE:
                    return (((this.visible) ? 1 : 0));
            };
            return (0);
        }
        public function setChannelData(_arg1:uint, _arg2:Number):void{
            switch (_arg1){
                case CHANNEL_ROTATION_X:
                    this.rotationX = _arg2;
                    return;
                case CHANNEL_ROTATION_Y:
                    this.rotationY = _arg2;
                    return;
                case CHANNEL_ROTATION_Z:
                    this.rotationZ = _arg2;
                    return;
                case CHANNEL_ROTATION_W:
                    this.rotationW = _arg2;
                    return;
                case CHANNEL_POSITION_X:
                    this.positionX = _arg2;
                    return;
                case CHANNEL_POSITION_Y:
                    this.positionY = _arg2;
                    return;
                case CHANNEL_POSITION_Z:
                    this.positionZ = _arg2;
                    return;
                case CHANNEL_VISIBLE:
                    this.visible = !((_arg2 == 0));
                    return;
            };
        }
        public function normalizeRotation():void{
            var _local1:Number = (1 / Math.sqrt(((((this.rotationX * this.rotationX) + (this.rotationY * this.rotationY)) + (this.rotationZ * this.rotationZ)) + (this.rotationW * this.rotationW))));
            this.rotationX = (this.rotationX * _local1);
            this.rotationY = (this.rotationY * _local1);
            this.rotationZ = (this.rotationZ * _local1);
            this.rotationW = (this.rotationW * _local1);
        }

    }
}//package ZDallasLib.Avatar2
