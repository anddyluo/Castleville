//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Avatar2{
    import __AS3__.vec.Vector;
    import flash.utils.ByteArray;
    import flash.geom.Vector3D;
    import flash.geom.Matrix3D;
    import __AS3__.vec.*;

    public class GameAnimationClip implements IAnimationClip {

        private static const m_version:uint = 5;

        public var fps:int = 0;
        private var m_name:String;
        private var m_startTimeInSecs:Number;
        private var m_endTimeInSecs:Number;
        private var m_isLooping:Boolean;
        private var m_skeletonName:String;
        private var m_time:Vector.<Number>;
        private var m_nextTimeDeltaInv:Vector.<Number>;
        private var m_jointAnimData:Vector.<Vector.<JointAnimData>>;
        private var m_triggers:Vector.<AnimationTriggerData>;
        private var m_dynamicAttributeData:Vector.<Vector.<int>>;

        public function GameAnimationClip(){
            this.m_time = new Vector.<Number>();
            this.m_nextTimeDeltaInv = new Vector.<Number>();
            this.m_jointAnimData = new Vector.<Vector.<JointAnimData>>();
            this.m_triggers = new Vector.<AnimationTriggerData>();
            this.m_dynamicAttributeData = new Vector.<Vector.<int>>();
            super();
        }
        public function set name(_arg1:String):void{
            this.m_name = new String(_arg1);
        }
        public function get name():String{
            return (new String(this.m_name));
        }
        public function get startTimeInSecs():Number{
            return (this.m_startTimeInSecs);
        }
        public function get endTimeInSecs():Number{
            return (this.m_endTimeInSecs);
        }
        public function get durationInSecs():Number{
            return ((this.m_endTimeInSecs - this.m_startTimeInSecs));
        }
        public function set skeletonName(_arg1:String):void{
            this.m_skeletonName = new String(_arg1);
        }
        public function get numJoints():uint{
            return ((((this.m_jointAnimData.length > 0)) ? this.m_jointAnimData[0].length : 0));
        }
        public function get numDynamicAttributes():uint{
            return ((((this.m_dynamicAttributeData.length > 0)) ? this.m_dynamicAttributeData[0].length : 0));
        }
        public function get averageFramesPerSecond():uint{
            return ((((this.m_time.length)==1) ? 0 : uint((this.m_time.length / this.durationInSecs))));
        }
        public function get numFrames():uint{
            return (this.m_time.length);
        }
        public function get skeletonName():String{
            return (this.m_skeletonName);
        }
        public function get triggers():Vector.<AnimationTriggerData>{
            return (this.m_triggers);
        }
        public function get isLooping():Boolean{
            return (this.m_isLooping);
        }
        public function set isLooping(_arg1:Boolean):void{
            this.m_isLooping = _arg1;
        }
        public function get byteArray():flash.utils.ByteArray{
            var _local6:uint;
            var _local9:Number;
            var _local10:Vector.<Number>;
            var _local11:uint;
            var _local12:Number;
            var _local13:Number;
            var _local14:Number;
            var _local15:Vector.<int>;
            var _local16:Boolean;
            var _local1:flash.utils.ByteArray = new flash.utils.ByteArray();
            _local1.writeUnsignedInt(m_version);
            _local1.writeFloat(this.m_startTimeInSecs);
            _local1.writeFloat(this.m_endTimeInSecs);
            _local1.writeInt(this.fps);
            _local1.writeBoolean(this.m_isLooping);
            _local1.writeInt(this.m_triggers.length);
            var _local2:uint;
            while (_local2 < this.m_triggers.length) {
                _local1.writeFloat(this.m_triggers[_local2].time);
                _local1.writeUTF(this.m_triggers[_local2].type);
                _local1.writeUTF(this.m_triggers[_local2].data);
                _local2++;
            };
            var _local3:uint = this.m_jointAnimData[0].length;
            _local1.writeUnsignedInt(_local3);
            var _local4:uint = this.m_dynamicAttributeData[0].length;
            _local1.writeUnsignedInt(_local4);
            var _local5:uint = this.m_time.length;
            _local1.writeUnsignedInt(_local5);
            _local6 = 0;
            while (_local6 < _local5) {
                _local1.writeFloat(this.m_time[_local6]);
                _local6++;
            };
            var _local7:uint;
            while (_local7 < _local3) {
                _local10 = new Vector.<Number>(_local5, true);
                _local11 = 0;
                while (_local11 < JointAnimData.NUM_CHANNELS) {
                    _local12 = -(Number.MAX_VALUE);
                    _local13 = Number.MAX_VALUE;
                    _local6 = 0;
                    while (_local6 < _local5) {
                        _local9 = this.m_jointAnimData[_local6][_local7].getChannelData(_local11);
                        _local10[_local6] = _local9;
                        if (_local9 < _local13){
                            _local13 = _local9;
                        };
                        if (_local9 > _local12){
                            _local12 = _local9;
                        };
                        _local6++;
                    };
                    if (_local13 == _local12){
                        _local1.writeByte(0);
                        _local1.writeFloat(_local13);
                    } else {
                        _local1.writeByte(1);
                        _local1.writeFloat(_local13);
                        _local1.writeFloat(_local12);
                        _local6 = 0;
                        while (_local6 < _local5) {
                            _local14 = ((_local10[_local6] - _local13) / (_local12 - _local13));
                            _local1.writeShort(int((_local14 * 32767)));
                            _local6++;
                        };
                    };
                    _local11++;
                };
                _local7++;
            };
            var _local8:uint;
            while (_local8 < _local4) {
                _local15 = new Vector.<int>(_local5, true);
                _local16 = true;
                _local6 = 0;
                while (_local6 < _local5) {
                    _local15[_local6] = this.m_dynamicAttributeData[_local6][_local8];
                    if (_local15[_local6] != _local15[0]){
                        _local16 = false;
                    };
                    _local6++;
                };
                if (_local16){
                    _local1.writeByte(0);
                    _local1.writeByte(_local15[0]);
                } else {
                    _local1.writeByte(1);
                    _local6 = 0;
                    while (_local6 < _local5) {
                        _local1.writeByte(this.m_dynamicAttributeData[_local6][_local8]);
                        _local6++;
                    };
                };
                _local8++;
            };
            _local1.position = 0;
            return (_local1);
        }
        protected function clearData():void{
            while (this.m_time.length) {
                this.m_time.AS3::pop();
            };
            while (this.m_nextTimeDeltaInv.length) {
                this.m_nextTimeDeltaInv.AS3::pop();
            };
            while (this.m_jointAnimData.length) {
                this.m_jointAnimData.AS3::pop();
            };
            while (this.m_dynamicAttributeData.length) {
                this.m_dynamicAttributeData.AS3::pop();
            };
        }
        public function initJointData(_arg1:flash.utils.ByteArray):void{
            var _local6:uint;
            var _local7:uint;
            var _local8:Number;
            var _local9:String;
            var _local10:String;
            var _local11:AnimationTriggerData;
            var _local12:Vector.<JointAnimData>;
            var _local13:Vector.<int>;
            var _local14:uint;
            var _local15:JointAnimData;
            var _local16:uint;
            var _local17:uint;
            var _local18:int;
            var _local19:uint;
            var _local20:Number;
            var _local21:Number;
            var _local22:Number;
            var _local23:Number;
            var _local24:Number;
            var _local25:int;
            this.clearData();
            var _local2:int = _arg1.readInt();
            this.m_startTimeInSecs = _arg1.readFloat();
            this.m_endTimeInSecs = _arg1.readFloat();
            if (_local2 >= 4){
                this.fps = _arg1.readInt();
                this.m_isLooping = _arg1.readBoolean();
            } else {
                this.m_isLooping = false;
            };
            this.m_triggers = new Vector.<AnimationTriggerData>();
            if (_local2 >= 2){
                _local6 = _arg1.readInt();
                _local7 = 0;
                while (_local7 < _local6) {
                    _local8 = _arg1.readFloat();
                    _local9 = _arg1.readUTF();
                    _local10 = _arg1.readUTF();
                    _local11 = new AnimationTriggerData(_local9, _local10, _local8);
                    this.m_triggers.AS3::push(_local11);
                    _local7++;
                };
            };
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint = _arg1.readUnsignedInt();
            if (_local2 < 5){
                while (_arg1.bytesAvailable) {
                    this.m_time.AS3::push(_arg1.readFloat());
                    _local12 = new Vector.<JointAnimData>();
                    _local13 = new Vector.<int>();
                    _local14 = 0;
                    while (_local14 < _local3) {
                        _local15 = new JointAnimData();
                        _local15.rotationX = _arg1.readFloat();
                        _local15.rotationY = _arg1.readFloat();
                        _local15.rotationZ = _arg1.readFloat();
                        _local15.rotationW = _arg1.readFloat();
                        _local15.positionX = _arg1.readFloat();
                        _local15.positionY = _arg1.readFloat();
                        _local15.positionZ = _arg1.readFloat();
                        _local15.visible = Boolean(_arg1.readByte());
                        _local15.flip = Boolean(_arg1.readByte());
                        _local12.AS3::push(_local15);
                        if (_local2 < 3){
                            _local15.visible = true;
                        };
                        _local14++;
                    };
                    _local14 = 0;
                    while (_local14 < _local4) {
                        _local13.AS3::push(_arg1.readInt());
                        _local14++;
                    };
                    this.m_jointAnimData.AS3::push(_local12);
                    this.m_dynamicAttributeData.AS3::push(_local13);
                };
            } else {
                _local16 = _arg1.readUnsignedInt();
                this.m_time = new Vector.<Number>(_local16, true);
                this.m_jointAnimData = new Vector.<Vector.<JointAnimData>>(_local16, true);
                this.m_dynamicAttributeData = new Vector.<Vector.<int>>(_local16, true);
                _local17 = 0;
                while (_local17 < _local16) {
                    this.m_time[_local17] = _arg1.readFloat();
                    this.m_dynamicAttributeData[_local17] = new Vector.<int>(_local4, true);
                    this.m_jointAnimData[_local17] = new Vector.<JointAnimData>(_local3, true);
                    _local14 = 0;
                    while (_local14 < _local3) {
                        this.m_jointAnimData[_local17][_local14] = new JointAnimData();
                        _local14++;
                    };
                    _local17++;
                };
                _local14 = 0;
                while (_local14 < _local3) {
                    _local18 = _arg1.readByte();
                    if (_local18 == 0){
                        _local23 = _arg1.readFloat();
                        _local17 = 0;
                        while (_local17 < _local16) {
                            this.m_jointAnimData[_local17][_local14].rotationX = _local23;
                            _local17++;
                        };
                    } else {
                        _local20 = _arg1.readFloat();
                        _local21 = _arg1.readFloat();
                        _local22 = (_local21 - _local20);
                        _local17 = 0;
                        while (_local17 < _local16) {
                            _local24 = (_arg1.readShort() / 32767);
                            this.m_jointAnimData[_local17][_local14].rotationX = (_local20 + (_local24 * _local22));
                            _local17++;
                        };
                    };
                    _local18 = _arg1.readByte();
                    if (_local18 == 0){
                        _local23 = _arg1.readFloat();
                        _local17 = 0;
                        while (_local17 < _local16) {
                            this.m_jointAnimData[_local17][_local14].rotationY = _local23;
                            _local17++;
                        };
                    } else {
                        _local20 = _arg1.readFloat();
                        _local21 = _arg1.readFloat();
                        _local22 = (_local21 - _local20);
                        _local17 = 0;
                        while (_local17 < _local16) {
                            _local24 = (_arg1.readShort() / 32767);
                            this.m_jointAnimData[_local17][_local14].rotationY = (_local20 + (_local24 * _local22));
                            _local17++;
                        };
                    };
                    _local18 = _arg1.readByte();
                    if (_local18 == 0){
                        _local23 = _arg1.readFloat();
                        _local17 = 0;
                        while (_local17 < _local16) {
                            this.m_jointAnimData[_local17][_local14].rotationZ = _local23;
                            _local17++;
                        };
                    } else {
                        _local20 = _arg1.readFloat();
                        _local21 = _arg1.readFloat();
                        _local22 = (_local21 - _local20);
                        _local17 = 0;
                        while (_local17 < _local16) {
                            _local24 = (_arg1.readShort() / 32767);
                            this.m_jointAnimData[_local17][_local14].rotationZ = (_local20 + (_local24 * _local22));
                            _local17++;
                        };
                    };
                    _local18 = _arg1.readByte();
                    if (_local18 == 0){
                        _local23 = _arg1.readFloat();
                        _local17 = 0;
                        while (_local17 < _local16) {
                            this.m_jointAnimData[_local17][_local14].rotationW = _local23;
                            _local17++;
                        };
                    } else {
                        _local20 = _arg1.readFloat();
                        _local21 = _arg1.readFloat();
                        _local22 = (_local21 - _local20);
                        _local17 = 0;
                        while (_local17 < _local16) {
                            _local24 = (_arg1.readShort() / 32767);
                            this.m_jointAnimData[_local17][_local14].rotationW = (_local20 + (_local24 * _local22));
                            _local17++;
                        };
                    };
                    _local18 = _arg1.readByte();
                    if (_local18 == 0){
                        _local23 = _arg1.readFloat();
                        _local17 = 0;
                        while (_local17 < _local16) {
                            this.m_jointAnimData[_local17][_local14].positionX = _local23;
                            _local17++;
                        };
                    } else {
                        _local20 = _arg1.readFloat();
                        _local21 = _arg1.readFloat();
                        _local22 = (_local21 - _local20);
                        _local17 = 0;
                        while (_local17 < _local16) {
                            _local24 = (_arg1.readShort() / 32767);
                            this.m_jointAnimData[_local17][_local14].positionX = (_local20 + (_local24 * _local22));
                            _local17++;
                        };
                    };
                    _local18 = _arg1.readByte();
                    if (_local18 == 0){
                        _local23 = _arg1.readFloat();
                        _local17 = 0;
                        while (_local17 < _local16) {
                            this.m_jointAnimData[_local17][_local14].positionY = _local23;
                            _local17++;
                        };
                    } else {
                        _local20 = _arg1.readFloat();
                        _local21 = _arg1.readFloat();
                        _local22 = (_local21 - _local20);
                        _local17 = 0;
                        while (_local17 < _local16) {
                            _local24 = (_arg1.readShort() / 32767);
                            this.m_jointAnimData[_local17][_local14].positionY = (_local20 + (_local24 * _local22));
                            _local17++;
                        };
                    };
                    _local18 = _arg1.readByte();
                    if (_local18 == 0){
                        _local23 = _arg1.readFloat();
                        _local17 = 0;
                        while (_local17 < _local16) {
                            this.m_jointAnimData[_local17][_local14].positionZ = _local23;
                            _local17++;
                        };
                    } else {
                        _local20 = _arg1.readFloat();
                        _local21 = _arg1.readFloat();
                        _local22 = (_local21 - _local20);
                        _local17 = 0;
                        while (_local17 < _local16) {
                            _local24 = (_arg1.readShort() / 32767);
                            this.m_jointAnimData[_local17][_local14].positionZ = (_local20 + (_local24 * _local22));
                            _local17++;
                        };
                    };
                    _local18 = _arg1.readByte();
                    if (_local18 == 0){
                        _local23 = _arg1.readFloat();
                        _local17 = 0;
                        while (_local17 < _local16) {
                            this.m_jointAnimData[_local17][_local14].visible = !((_local23 == 0));
                            _local17++;
                        };
                    } else {
                        _local20 = _arg1.readFloat();
                        _local21 = _arg1.readFloat();
                        _local22 = (_local21 - _local20);
                        _local17 = 0;
                        while (_local17 < _local16) {
                            _local24 = (_arg1.readShort() / 32767);
                            this.m_jointAnimData[_local17][_local14].visible = !(((_local20 + (_local24 * _local22)) == 0));
                            _local17++;
                        };
                    };
                    _local17 = 0;
                    while (_local17 < _local16) {
                        this.m_jointAnimData[_local17][_local14].normalizeRotation();
                        _local17++;
                    };
                    _local14++;
                };
                _local19 = 0;
                while (_local19 < _local4) {
                    _local18 = _arg1.readByte();
                    if (_local18 == 0){
                        _local25 = _arg1.readByte();
                        _local17 = 0;
                        while (_local17 < _local16) {
                            this.m_dynamicAttributeData[_local17][_local19] = _local25;
                            _local17++;
                        };
                    } else {
                        _local17 = 0;
                        while (_local17 < _local16) {
                            this.m_dynamicAttributeData[_local17][_local19] = _arg1.readByte();
                            _local17++;
                        };
                    };
                    _local19++;
                };
            };
            this.m_nextTimeDeltaInv = new Vector.<Number>(this.m_time.length, true);
            this.m_nextTimeDeltaInv[(this.m_time.length - 1)] = 1;
            var _local5:uint;
            while (_local5 < (this.m_time.length - 1)) {
                this.m_nextTimeDeltaInv[_local5] = (1 / (this.m_time[(_local5 + 1)] - this.m_time[_local5]));
                _local5++;
            };
            if (_local2 < 4){
                this.fps = (((this.m_time.length > 1)) ? Math.round((1 / (this.m_time[1] - this.m_time[0]))) : 0);
            };
        }
        public function hintStartEndTime(_arg1:Number, _arg2:Number):void{
            this.m_startTimeInSecs = _arg1;
            this.m_endTimeInSecs = _arg2;
        }
        public function setJointData(_arg1:Vector.<Number>, _arg2:Vector.<Vector.<JointAnimData>>, _arg3:Vector.<Vector.<int>>):void{
            var _local9:uint;
            var _local10:JointAnimData;
            var _local11:flash.geom.Vector3D;
            this.m_time = _arg1;
            this.m_jointAnimData = _arg2;
            this.m_dynamicAttributeData = _arg3;
            this.fps = (((_arg1.length > 1)) ? Math.round((1 / (_arg1[1] - _arg1[0]))) : 0);
            this.m_nextTimeDeltaInv = new Vector.<Number>(this.m_time.length, true);
            this.m_nextTimeDeltaInv[(this.m_time.length - 1)] = 1;
            var _local4:uint;
            while (_local4 < (this.m_time.length - 1)) {
                this.m_nextTimeDeltaInv[_local4] = (1 / (this.m_time[(_local4 + 1)] - this.m_time[_local4]));
                _local4++;
            };
            var _local5:flash.geom.Matrix3D = new flash.geom.Matrix3D();
            var _local6:uint = this.m_jointAnimData.length;
            var _local7:uint = this.m_jointAnimData[0].length;
            var _local8:uint;
            while (_local8 < _local6) {
                _local9 = 0;
                while (_local9 < _local7) {
                    _local10 = this.m_jointAnimData[_local8][_local9];
                    _local5.identity();
                    _local5.prependRotation(_local10.rotationZ, flash.geom.Vector3D.Z_AXIS);
                    _local5.prependRotation(_local10.rotationY, flash.geom.Vector3D.Y_AXIS);
                    _local5.prependRotation(_local10.rotationX, flash.geom.Vector3D.X_AXIS);
                    _local11 = _local5.decompose("quaternion")[1];
                    _local10.rotationX = _local11.x;
                    _local10.rotationY = _local11.y;
                    _local10.rotationZ = _local11.z;
                    _local10.rotationW = _local11.w;
                    _local9++;
                };
                _local8++;
            };
        }
        public function evaluate(_arg1:Number, _arg2:Vector.<Number>, _arg3:Skeleton, _arg4:uint, _arg5:uint, _arg6:Boolean):Boolean{
            var _local9:uint;
            var _local10:uint;
            var _local11:Number;
            var _local12:uint;
            var _local13:Vector.<JointAnimData>;
            var _local14:JointAnimData;
            var _local15:Vector.<JointAnimData>;
            var _local16:Vector.<JointAnimData>;
            var _local17:JointAnimData;
            var _local18:JointAnimData;
            var _local7:Boolean;
            var _local8:uint = this.m_time.length;
            _local9 = _arg2[0];
            if (_arg1 <= this.m_time[0]){
                _local9 = 0;
                _local11 = 0;
            } else {
                if (_arg1 >= this.m_time[(_local8 - 1)]){
                    _local9 = (_local8 - 1);
                    _local11 = 0;
                } else {
                    while (((((_local9 + 1) < _local8)) && ((_arg1 > this.m_time[(_local9 + 1)])))) {
                        _local9++;
                    };
                    _local11 = ((_arg1 - this.m_time[_local9]) * this.m_nextTimeDeltaInv[_local9]);
                };
            };
            if ((((_local11 == 0)) || ((_arg6 == false)))){
                _local13 = this.m_jointAnimData[_local9];
                _local10 = 0;
                while (_local10 < _arg4) {
                    _local14 = _local13[_local10];
                    _arg3.joints[_local10].setCachedDataFromAnim(_local14);
                    _local10++;
                };
            } else {
                _local15 = this.m_jointAnimData[_local9];
                _local16 = this.m_jointAnimData[(_local9 + 1)];
                _local10 = 0;
                while (_local10 < _arg4) {
                    _local17 = _local15[_local10];
                    _local18 = _local16[_local10];
                    _arg3.joints[_local10].interpCachedDataFromAnim(_local11, _local17, _local18);
                    _local10++;
                };
            };
            _local7 = true;
            _arg2[0] = _local9;
            _local12 = 0;
            while (_local12 < _arg5) {
                _arg3.dynamicAttributes[_local12] = this.m_dynamicAttributeData[_local9][_local12];
                _local12++;
            };
            return (_local7);
        }

    }
}//package ZDallasLib.Avatar2
