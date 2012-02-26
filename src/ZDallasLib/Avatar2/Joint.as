//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Avatar2{
    import flash.geom.Vector3D;
    import __AS3__.vec.Vector;
    import flash.geom.Matrix3D;
    import __AS3__.vec.*;

    public class Joint {

        public static const TRANSLATEX:uint = 0;
        public static const TRANSLATEY:uint = 1;
        public static const TRANSLATEZ:uint = 2;
        public static const ROTATEZ:uint = 3;
        public static const ROTATEY:uint = 4;
        public static const ROTATEX:uint = 5;
        public static const SCALEZ:uint = 6;
        public static const SCALEY:uint = 7;
        public static const SCALEX:uint = 8;
        public static const VISIBILITY:uint = 9;
        public static const SORTCONTROL:uint = 10;
        public static const NUMCHANNELS:uint = 11;

        private static var m_tmpVec:flash.geom.Vector3D = new flash.geom.Vector3D();
        private static var m_tmpVec1:Vector.<Number> = Vector.<Number>([0, 0, 0]);
        private static var m_tmpVec2:Vector.<Number> = Vector.<Number>([0, 0, 0]);
        private static var m_tmpRecomposeVectors:Vector.<Vector3D> = Vector.<flash.geom.Vector3D>([new flash.geom.Vector3D(0, 0, 0), new flash.geom.Vector3D(0, 0, 0, 1), new flash.geom.Vector3D(1, 1, 1)]);

        private var m_dirty:Boolean = false;
        public var channels:Vector.<Number>;
        public var id:String;
        public var isVisible:Boolean = true;
        public var isReachable:Boolean = false;
        public var name:String;
        public var localMat:flash.geom.Matrix3D;
        public var worldMat:flash.geom.Matrix3D;
        public var cachedMat:flash.geom.Matrix3D;
        public var localPos:flash.geom.Vector3D;
        public var worldPos:flash.geom.Vector3D;
        public var parent:int;
        public var children:Vector.<int>;

        public function Joint(_arg1:String){
            this.channels = new Vector.<Number>(NUMCHANNELS, true);
            this.id = new String();
            this.name = new String();
            this.localMat = new flash.geom.Matrix3D();
            this.worldMat = new flash.geom.Matrix3D();
            this.cachedMat = new flash.geom.Matrix3D();
            this.localPos = new flash.geom.Vector3D();
            this.worldPos = new flash.geom.Vector3D();
            this.children = new Vector.<int>();
            super();
            this.id = _arg1;
        }
        public function addParent(_arg1:int):void{
            this.parent = _arg1;
        }
        public function addChild(_arg1:int):void{
            this.children.AS3::push(_arg1);
        }
        public function setLocalTransform(_arg1:Vector.<Number>, _arg2:flash.geom.Vector3D):void{
            this.localMat = new flash.geom.Matrix3D(_arg1);
            this.localPos = new flash.geom.Vector3D(_arg2.x, _arg2.y, _arg2.z);
        }
        public function setCachedDataFromAnim(_arg1:JointAnimData):void{
            var _local2:flash.geom.Vector3D = m_tmpRecomposeVectors[1];
            _local2.x = _arg1.rotationX;
            _local2.y = _arg1.rotationY;
            _local2.z = _arg1.rotationZ;
            _local2.w = _arg1.rotationW;
            this.cachedMat.recompose(m_tmpRecomposeVectors, "quaternion");
            this.localPos.x = _arg1.positionX;
            this.localPos.y = _arg1.positionY;
            this.localPos.z = _arg1.positionZ;
            this.isVisible = _arg1.visible;
            this.m_dirty = false;
        }
        public function interpCachedDataFromAnim(_arg1:Number, _arg2:JointAnimData, _arg3:JointAnimData):void{
            this.isVisible = _arg2.visible;
            this.localPos.x = (_arg2.positionX + (_arg1 * (_arg3.positionX - _arg2.positionX)));
            this.localPos.y = (_arg2.positionY + (_arg1 * (_arg3.positionY - _arg2.positionY)));
            this.localPos.z = (_arg2.positionZ + (_arg1 * (_arg3.positionZ - _arg2.positionZ)));
            var _local4:Number = (1 - _arg1);
            if (((((_arg2.rotationX * _arg3.rotationX) + (_arg2.rotationY * _arg3.rotationY)) + (_arg2.rotationZ * _arg3.rotationZ)) + (_arg2.rotationW * _arg3.rotationW)) < 0){
                _local4 = (_local4 * -1);
            };
            var _local5:Number = ((_local4 * _arg2.rotationX) + (_arg1 * _arg3.rotationX));
            var _local6:Number = ((_local4 * _arg2.rotationY) + (_arg1 * _arg3.rotationY));
            var _local7:Number = ((_local4 * _arg2.rotationZ) + (_arg1 * _arg3.rotationZ));
            var _local8:Number = ((_local4 * _arg2.rotationW) + (_arg1 * _arg3.rotationW));
            var _local9:Number = Math.sqrt(((((_local5 * _local5) + (_local6 * _local6)) + (_local7 * _local7)) + (_local8 * _local8)));
            var _local10:Number = (1 / _local9);
            var _local11:flash.geom.Vector3D = m_tmpRecomposeVectors[1];
            _local11.x = (_local5 * _local10);
            _local11.y = (_local6 * _local10);
            _local11.z = (_local7 * _local10);
            _local11.w = (_local8 * _local10);
            this.cachedMat.recompose(m_tmpRecomposeVectors, "quaternion");
            this.m_dirty = false;
        }
        public function buildWorldMat(_arg1:flash.geom.Matrix3D, _arg2:flash.geom.Vector3D):void{
            if (this.m_dirty){
                this.cachedMat.identity();
                this.cachedMat.prependRotation(this.channels[Joint.ROTATEZ], flash.geom.Vector3D.Z_AXIS);
                this.cachedMat.prependRotation(this.channels[Joint.ROTATEY], flash.geom.Vector3D.Y_AXIS);
                this.cachedMat.prependRotation(this.channels[Joint.ROTATEX], flash.geom.Vector3D.X_AXIS);
                this.localPos.x = this.channels[Joint.TRANSLATEX];
                this.localPos.y = this.channels[Joint.TRANSLATEY];
                this.localPos.z = this.channels[Joint.TRANSLATEZ];
            };
            m_tmpVec1[0] = this.localPos.x;
            m_tmpVec1[1] = this.localPos.y;
            m_tmpVec1[2] = this.localPos.z;
            _arg1.transformVectors(m_tmpVec1, m_tmpVec2);
            this.worldPos.x = m_tmpVec2[0];
            this.worldPos.y = m_tmpVec2[1];
            this.worldPos.z = m_tmpVec2[2];
            this.worldPos.x = (this.worldPos.x + _arg2.x);
            this.worldPos.y = (this.worldPos.y + _arg2.y);
            this.worldPos.z = (this.worldPos.z + _arg2.z);
            this.worldMat.identity();
            this.worldMat.append(this.cachedMat);
            this.worldMat.append(this.localMat);
            this.worldMat.append(_arg1);
        }
        public function setChannel(_arg1:uint, _arg2:Number):void{
            this.channels[_arg1] = _arg2;
            this.m_dirty = true;
        }

    }
}//package ZDallasLib.Avatar2
