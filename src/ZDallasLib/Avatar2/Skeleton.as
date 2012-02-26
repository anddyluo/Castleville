//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Avatar2{
    import flash.geom.Vector3D;
    import __AS3__.vec.Vector;
    import Engine.Helpers.Vector2;
    import flash.geom.Matrix3D;
    import flash.geom.Matrix;
    import flash.filters.ColorMatrixFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.display.Bitmap;
    import flash.geom.Transform;
    import flash.utils.ByteArray;
    import flash.display.Sprite;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import __AS3__.vec.*;

    public class Skeleton {

        private static const m_version:uint = 2;
        protected static const m_zeroVector:flash.geom.Vector3D = new flash.geom.Vector3D();
        private static const pathCommands:Vector.<int> = Vector.<int>([1, 2, 2, 2]);
        private static const debugPathCommands:Vector.<int> = Vector.<int>([1, 2, 2, 2, 2]);

        private static var m_workVecArray:Vector.<Vector2>;
        protected static var m_workMat3D:flash.geom.Matrix3D = new flash.geom.Matrix3D();
        protected static var m_workMat:flash.geom.Matrix = new flash.geom.Matrix();
        private static var pathData:Vector.<Number> = Vector.<Number>([0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
        private static var pathData3DIn:Vector.<Number> = Vector.<Number>([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
        private static var pathData3DOut:Vector.<Number> = Vector.<Number>([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
        private static var tmpData3DOut:Vector.<Number> = Vector.<Number>([0, 0, 0, 0, 0, 0, 0, 0, 0]);
        private static var tmpData3DIn:Vector.<Number> = Vector.<Number>([1, 0, 0, 0, 1, 0, 0, 0, 0]);
        private static var tmpPosIn:Vector.<Number> = Vector.<Number>([0, 0, 0]);
        private static var tmpPosOut:Vector.<Number> = Vector.<Number>([0, 0, 0]);
        private static var tmpColorMatrixFilter:flash.filters.ColorMatrixFilter = new flash.filters.ColorMatrixFilter();
        private static var tmpColorTransform:flash.geom.ColorTransform = new flash.geom.ColorTransform();
        private static var tmpZeroPoint:flash.geom.Point = new flash.geom.Point(0, 0);

        public var joints:Vector.<Joint>;
        public var dynamicAttributes:Vector.<int>;
        public var forceUnreachableJointUpdate:Boolean = false;
        protected var m_dynamicAttributeNames:Vector.<String>;
        protected var m_skinContainers:Array;
        protected var m_bitmaps:Vector.<Bitmap>;
        protected var m_bitmapTransforms:Vector.<Transform>;
        protected var m_savedJoints:flash.utils.ByteArray;
        protected var m_jointStack:Vector.<Joint>;
        protected var m_matrixStack:Vector.<Matrix>;
        protected var m_sortedJoints:Vector.<uint>;
        protected var m_identity:flash.geom.Matrix3D;
        protected var m_drawDebugBounds:Boolean = false;
        private var m_fileData:flash.utils.ByteArray;
        private var m_scale:Number = 1;
        private var m_debugSprite:flash.display.Sprite;

        public function Skeleton(){
            this.joints = new Vector.<Joint>();
            this.dynamicAttributes = new Vector.<int>();
            this.m_dynamicAttributeNames = new Vector.<String>();
            this.m_skinContainers = [];
            this.m_bitmaps = new Vector.<flash.display.Bitmap>();
            this.m_bitmapTransforms = new Vector.<flash.geom.Transform>();
            this.m_jointStack = new Vector.<Joint>();
            this.m_matrixStack = new Vector.<flash.geom.Matrix>();
            this.m_identity = new flash.geom.Matrix3D();
            super();
            this.m_identity.identity();
            if (m_workVecArray == null){
                m_workVecArray = new Vector.<Engine.Helpers.Vector2>();
                m_workVecArray.AS3::push(new Engine.Helpers.Vector2(0, 0));
                m_workVecArray.AS3::push(new Engine.Helpers.Vector2(0, 0));
                m_workVecArray.AS3::push(new Engine.Helpers.Vector2(0, 0));
                m_workVecArray.AS3::push(new Engine.Helpers.Vector2(0, 0));
            };
        }
        private static function compareSkinContainerSortOrder(_arg1:SkinContainerRef, _arg2:SkinContainerRef):int{
            return ((((_arg1.sortValue)<_arg2.sortValue) ? -1 : (((_arg1.sortValue)>_arg2.sortValue) ? 1 : 0)));
        }

        public function clone():Skeleton{
            var _local1:Skeleton = new Skeleton();
            _local1.initSkeleton(this.byteArray);
            return (_local1);
        }
        public function get scale():Number{
            return (this.m_scale);
        }
        public function set scale(_arg1:Number):void{
            this.m_scale = _arg1;
        }
        public function get skinContainers():Array{
            return (this.m_skinContainers);
        }
        public function get drawDebugBounds():Boolean{
            return (this.m_drawDebugBounds);
        }
        public function set drawDebugBounds(_arg1:Boolean):void{
            this.m_drawDebugBounds = _arg1;
            if (((((!(this.m_drawDebugBounds)) && (this.m_debugSprite))) && (this.m_debugSprite.parent))){
                this.m_debugSprite.parent.removeChild(this.m_debugSprite);
            };
        }
        public function get byteArray():flash.utils.ByteArray{
            var _local2:uint;
            var _local3:uint;
            var _local5:Joint;
            var _local6:String;
            var _local7:Vector.<Number>;
            var _local8:uint;
            var _local9:Vector.<Number>;
            var _local10:int;
            var _local11:Vector.<int>;
            var _local12:uint;
            if (!this.m_fileData){
                this.m_fileData = new flash.utils.ByteArray();
            };
            this.m_fileData.clear();
            this.m_fileData.writeUnsignedInt(m_version);
            this.m_fileData.writeFloat(this.m_scale);
            var _local1:uint = this.joints.length;
            this.m_fileData.writeUnsignedInt(_local1);
            _local2 = 0;
            while (_local2 < _local1) {
                _local5 = this.joints[_local2];
                _local6 = _local5.id;
                if (_local5.name.length > 0){
                    _local6 = _local5.name;
                };
                this.m_fileData.writeUTF(_local6);
                _local7 = _local5.localMat.rawData;
                _local8 = _local7.length;
                this.m_fileData.writeInt(_local8);
                _local3 = 0;
                while (_local3 < _local8) {
                    this.m_fileData.writeFloat(_local7[_local3]);
                    _local3++;
                };
                _local9 = _local5.channels;
                this.m_fileData.writeInt(_local9.length);
                _local10 = 0;
                while (_local10 < _local9.length) {
                    this.m_fileData.writeFloat(_local9[_local10]);
                    _local10++;
                };
                this.m_fileData.writeInt(_local5.parent);
                _local11 = _local5.children;
                _local12 = _local11.length;
                this.m_fileData.writeInt(_local12);
                _local3 = 0;
                while (_local3 < _local12) {
                    this.m_fileData.writeInt(_local11[_local3]);
                    _local3++;
                };
                _local2++;
            };
            var _local4:uint = this.dynamicAttributes.length;
            this.m_fileData.writeUnsignedInt(_local4);
            _local2 = 0;
            while (_local2 < _local4) {
                this.m_fileData.writeUTF(this.m_dynamicAttributeNames[_local2]);
                this.m_fileData.writeInt(this.dynamicAttributes[_local2]);
                _local2++;
            };
            this.m_fileData.position = 0;
            return (this.m_fileData);
        }
        public function initSkeleton(_arg1:flash.utils.ByteArray):void{
            while (this.joints.length) {
                this.joints.AS3::pop();
            };
            while (this.m_dynamicAttributeNames.length) {
                this.m_dynamicAttributeNames.AS3::pop();
            };
            while (this.dynamicAttributes.length) {
                this.dynamicAttributes.AS3::pop();
            };
            this.readFormat(_arg1);
            this.updateJoints();
        }
        protected function readFormat(_arg1:flash.utils.ByteArray):void{
            var _local7:Joint;
            var _local8:int;
            var _local9:Vector.<Number>;
            var _local10:flash.geom.Vector3D;
            var _local11:int;
            var _local12:int;
            var _local13:int;
            var _local2:int = _arg1.readInt();
            if (_local2 > 1){
                this.m_scale = _arg1.readFloat();
            };
            var _local3:uint;
            var _local4:uint;
            var _local5:int = _arg1.readUnsignedInt();
            _local4 = 0;
            while (_local4 < _local5) {
                _local7 = new Joint(_arg1.readUTF().AS3::toLowerCase());
                _local8 = _arg1.readInt();
                _local9 = new Vector.<Number>(_local8, true);
                _local3 = 0;
                while (_local3 < _local8) {
                    _local9[_local3] = _arg1.readFloat();
                    _local3++;
                };
                _local10 = new flash.geom.Vector3D();
                if (_local2 > 1){
                    _local12 = _arg1.readInt();
                    _local13 = 0;
                    while (_local13 < _local12) {
                        _local7.setChannel(_local13, _arg1.readFloat());
                        _local13++;
                    };
                } else {
                    _local10.x = _arg1.readFloat();
                    _local10.y = _arg1.readFloat();
                    _local10.z = _arg1.readFloat();
                };
                _local7.setLocalTransform(_local9, _local10);
                _local7.addParent(_arg1.readInt());
                _local11 = _arg1.readInt();
                _local3 = 0;
                while (_local3 < _local11) {
                    _local7.addChild(_arg1.readInt());
                    _local3++;
                };
                this.joints[_local4] = _local7;
                _local4++;
            };
            this.setupSortedJoints();
            var _local6:uint = _arg1.readUnsignedInt();
            _local3 = 0;
            while (_local3 < _local6) {
                this.m_dynamicAttributeNames.AS3::push(_arg1.readUTF().AS3::toLowerCase());
                this.dynamicAttributes.AS3::push(_arg1.readInt());
                _local3++;
            };
        }
        protected function setupSortedJoints():void{
            var _local3:Joint;
            var _local4:uint;
            var _local5:uint;
            this.m_sortedJoints = new Vector.<uint>();
            this.m_sortedJoints.AS3::push(0);
            var _local1:uint;
            var _local2:uint = this.joints.length;
            while (this.m_sortedJoints.length < _local2) {
                _local3 = this.joints[this.m_sortedJoints[_local1]];
                _local4 = _local3.children.length;
                _local5 = 0;
                while (_local5 < _local4) {
                    this.m_sortedJoints.AS3::push(_local3.children[_local5]);
                    _local5++;
                };
                _local1++;
            };
        }
        public function get numJoints():uint{
            return (this.joints.length);
        }
        public function jointName(_arg1:uint):String{
            if (_arg1 < this.joints.length){
                return (new String(this.joints[_arg1].id));
            };
            return (null);
        }
        public function jointID(_arg1:String):int{
            var _local2:uint;
            var _local3:uint;
            if (_arg1){
                _local2 = this.joints.length;
                _local3 = 0;
                while (_local3 < _local2) {
                    if (this.joints[_local3].id == _arg1.AS3::toLowerCase()){
                        return (_local3);
                    };
                    _local3++;
                };
            };
            return (-1);
        }
        public function get numDynamicAttributes():uint{
            return (this.dynamicAttributes.length);
        }
        public function dynamicAttributeID(_arg1:String):int{
            var _local2:uint;
            var _local3:uint;
            if (_arg1){
                _local2 = this.m_dynamicAttributeNames.length;
                _local3 = 0;
                while (_local3 < _local2) {
                    if (this.m_dynamicAttributeNames[_local3] == _arg1.AS3::toLowerCase()){
                        return (_local3);
                    };
                    _local3++;
                };
            };
            return (-1);
        }
        public function jointIDFromJointName(_arg1:String):int{
            var _local2:uint;
            var _local3:uint;
            if (_arg1){
                _local2 = this.joints.length;
                _local3 = 0;
                while (_local3 < _local2) {
                    if (this.joints[_local3].name == _arg1.AS3::toLowerCase()){
                        return (_local3);
                    };
                    _local3++;
                };
            };
            return (-1);
        }
        public function addSkinContainer(_arg1:SkinContainer, _arg2:String, _arg3:Boolean):SkinContainerRef{
            var _local5:int;
            var _local6:Joint;
            var _local4:SkinContainerRef;
            if (!this.isSkinContainerAttached(_arg1)){
                _local5 = this.jointID(_arg2);
                if (_local5 != -1){
                    _local4 = new SkinContainerRef(_arg1);
                    _local4.jointID = _local5;
                    _local4.sequenceAttributeID = this.dynamicAttributeID(_arg1.m_sequenceAttributeName);
                    _local4.scaleContainer = _arg3;
                    this.m_skinContainers.AS3::push(_local4);
                    while (_local5 >= 0) {
                        _local6 = this.joints[_local5];
                        _local6.isReachable = true;
                        _local5 = _local6.parent;
                    };
                };
            };
            return (_local4);
        }
        public function isSkinContainerAttached(_arg1:SkinContainer):Boolean{
            var _local3:SkinContainerRef;
            var _local2:uint;
            while (_local2 < this.m_skinContainers.length) {
                _local3 = this.m_skinContainers[_local2];
                if (_local3.skinContainer == _arg1){
                    return (true);
                };
                _local2++;
            };
            return (false);
        }
        public function removeSkinContainer(_arg1:SkinContainer):void{
            var _local3:SkinContainerRef;
            var _local4:uint;
            var _local2:uint;
            while (_local2 < this.m_skinContainers.length) {
                _local3 = this.m_skinContainers[_local2];
                if (_local3.skinContainer == _arg1){
                    _local3.releaseBitmaps();
                    this.m_skinContainers.AS3::splice(_local2, 1);
                    this.joints[_local3.jointID].isReachable = false;
                    _local4 = 0;
                    while (_local4 < this.joints.length) {
                        if ((((this.joints[_local4].parent == _local3.jointID)) && (this.joints[_local4].isReachable))){
                            this.joints[_local3.jointID].isReachable = true;
                            break;
                        };
                        _local4++;
                    };
                    return;
                };
                _local2++;
            };
        }
        public function getSkinContainerByName(_arg1:String):SkinContainer{
            var _local2:SkinContainerRef;
            for each (_local2 in this.m_skinContainers) {
                if (_local2.skinContainer.m_name == _arg1){
                    return (_local2.skinContainer);
                };
            };
            return (null);
        }
        public function getSkinContainerRefByName(_arg1:String):SkinContainerRef{
            var _local2:SkinContainerRef;
            for each (_local2 in this.m_skinContainers) {
                if (_local2.skinContainer.m_name == _arg1){
                    return (_local2);
                };
            };
            return (null);
        }
        public function applySkin(_arg1:SkinIntermediary):void{
            var _local2:SkinContainer;
            this.clearSkin();
            for each (_local2 in _arg1.skinContainers) {
                this.addSkinContainer(_local2, _local2.m_jointName, true);
            };
        }
        public function clearSkin():void{
            var _local1:Joint;
            var _local2:SkinContainerRef;
            while (this.m_skinContainers.length) {
                _local2 = this.m_skinContainers.AS3::pop();
                _local2.releaseBitmaps();
            };
            if (((this.m_debugSprite) && (this.m_debugSprite.parent))){
                this.m_debugSprite.parent.removeChild(this.m_debugSprite);
            };
            for each (_local1 in this.joints) {
                _local1.isReachable = false;
            };
        }
        public function applyJointData(_arg1:int, _arg2:uint, _arg3:Number):void{
            this.joints[_arg1].setChannel(_arg2, _arg3);
        }
        public function applyDynamicAttribute(_arg1:int, _arg2:int):void{
            this.dynamicAttributes[_arg1] = _arg2;
        }
        public function setJointData(_arg1:Vector.<JointAnimData>):void{
            var _local4:JointAnimData;
            var _local2:uint = _arg1.length;
            var _local3:uint;
            while (_local3 < _local2) {
                _local4 = _arg1[_local3];
                this.joints[_local3].setCachedDataFromAnim(_local4);
                _local3++;
            };
        }
        public function setDynamicAttributeData(_arg1:Vector.<int>):void{
            var _local2:uint = _arg1.length;
            var _local3:uint;
            while (_local3 < _local2) {
                this.dynamicAttributes[_local3] = _arg1[_local3];
                _local3++;
            };
        }
        public function updateJoints(_arg1:Boolean=false):void{
            var _local3:Joint;
            var _local4:Joint;
            var _local2:flash.geom.Matrix3D = m_workMat3D;
            _local2.identity();
            if (_arg1){
                _local2.appendScale(-1, 1, 1);
            };
            var _local5:uint = this.m_sortedJoints.length;
            this.joints[0].buildWorldMat(_local2, m_zeroVector);
            var _local6:uint = 1;
            while (_local6 < _local5) {
                _local3 = this.joints[_local6];
                if (((_local3.isReachable) || (this.forceUnreachableJointUpdate))){
                    _local4 = this.joints[_local3.parent];
                    _local3.buildWorldMat(_local4.worldMat, _local4.worldPos);
                };
                _local6++;
            };
        }
        public function renderToSurface(_arg1:flash.display.Sprite):void{
            var _local7:Vector.<int>;
            var _local8:uint;
            var _local9:uint;
            var _local10:Number;
            var _local11:Number;
            var _local2:uint;
            var _local3:uint = this.joints.length;
            var _local4:flash.geom.Vector3D = new flash.geom.Vector3D();
            var _local5:flash.geom.Vector3D = new flash.geom.Vector3D();
            var _local6:uint;
            while (_local6 < _local3) {
                _local4.x = this.joints[_local6].worldPos.x;
                _local4.y = this.joints[_local6].worldPos.y;
                if (!this.joints[_local6].isReachable){
                    _arg1.graphics.beginFill(6737151, 0.3);
                    _arg1.graphics.lineStyle(1, 6737151, 0.3);
                } else {
                    if (this.joints[_local6].isVisible){
                        _arg1.graphics.beginFill(0, 1);
                        _arg1.graphics.lineStyle(1, 0, 1);
                    } else {
                        _arg1.graphics.beginFill(0, 0.3);
                        _arg1.graphics.lineStyle(1, 0, 0.3);
                    };
                };
                _arg1.graphics.drawCircle((_local4.x * this.m_scale), (-(_local4.y) * this.m_scale), 3);
                _local7 = this.joints[_local6].children;
                _local8 = _local7.length;
                _local9 = 0;
                while (_local9 < _local8) {
                    _local5.x = (this.joints[_local7[_local9]].worldPos.x * this.m_scale);
                    _local5.y = (this.joints[_local7[_local9]].worldPos.y * this.m_scale);
                    if (!this.joints[_local7[_local9]].isReachable){
                        _arg1.graphics.beginFill(6737151, 0.3);
                        _arg1.graphics.lineStyle(1, 6737151, 0.3);
                    } else {
                        if (this.joints[_local7[_local9]].isVisible){
                            _arg1.graphics.beginFill(0, 1);
                            _arg1.graphics.lineStyle(1, 0, 1);
                        } else {
                            _arg1.graphics.beginFill(0, 0.3);
                            _arg1.graphics.lineStyle(1, 0, 0.3);
                        };
                    };
                    _arg1.graphics.moveTo((_local4.x * this.m_scale), (-(_local4.y) * this.m_scale));
                    _arg1.graphics.lineTo(_local5.x, -(_local5.y));
                    _local10 = ((_local4.x * this.m_scale) - _local5.x);
                    _local11 = ((-(_local4.y) * this.m_scale) - -(_local5.y));
                    _local9++;
                };
                _local6++;
            };
            _arg1.graphics.endFill();
        }
        public function renderSkinSprite(_arg1:flash.display.Sprite, _arg2:Boolean=false):void{
            var _local5:flash.geom.Matrix3D;
            var _local6:SkinContainer;
            var _local7:SkinContainerRef;
            var _local8:SkinContainerRef;
            var _local9:Joint;
            var _local10:flash.display.BitmapData;
            var _local12:Number;
            var _local13:Number;
            var _local14:uint;
            var _local16:flash.display.Bitmap;
            var _local17:flash.geom.Vector3D;
            var _local19:flash.geom.Rectangle;
            var _local20:Number;
            var _local21:Number;
            var _local22:flash.geom.Matrix3D;
            var _local23:flash.display.Bitmap;
            var _local3:uint = this.m_skinContainers.length;
            var _local4:flash.geom.Matrix = m_workMat;
            var _local11:int;
            var _local15:Boolean;
            _local14 = 0;
            while (_local14 < _local3) {
                _local8 = _local7;
                _local7 = this.m_skinContainers[_local14];
                if (_local7.isVisible){
                    _local6 = _local7.skinContainer;
                    _local9 = this.joints[_local7.jointID];
                    if (_local9.isVisible){
                        _local11 = 0;
                        _local10 = null;
                        if (_local7.sequenceAttributeID > -1){
                            _local11 = this.dynamicAttributes[_local7.sequenceAttributeID];
                        };
                        _local10 = _local7.getBitmapData(_local11);
                        _local7.currentBitmap = _local10;
                        if (_local10){
                            _local5 = _local7.currentMat3D;
                            _local5.identity();
                            if (!_local7.mat3D[_local11]){
                                _local19 = _local6.m_cropSourceRect[_local11];
                                _local20 = ((_local19) ? _local19.width : _local10.width);
                                _local21 = (_local6.m_width / _local20);
                                _local22 = new flash.geom.Matrix3D();
                                if (_local19){
                                    _local22.appendTranslation(-(_local19.x), -(_local19.y), 0);
                                };
                                _local22.appendScale(_local21, _local21, _local21);
                                _local22.append(_local6.m_Mat3D);
                                _local7.mat3D[_local11] = _local22;
                            };
                            _local5.append(_local7.mat3D[_local11]);
                            _local5.append(_local9.worldMat);
                            _local17 = _local9.worldPos;
                            if (_local7.scaleContainer){
                                _local5.appendTranslation(_local17.x, _local17.y, _local17.z);
                                _local5.appendScale(this.m_scale, -(this.m_scale), this.m_scale);
                            } else {
                                _local5.appendTranslation((_local17.x * this.m_scale), (_local17.y * this.m_scale), (_local17.z * this.m_scale));
                                _local5.appendScale(1, -1, 1);
                            };
                            _local5.transformVectors(tmpPosIn, tmpPosOut);
                            _local7.sortValue = tmpPosOut[2];
                            if (((_local8) && ((_local7.sortValue < _local8.sortValue)))){
                                _local15 = true;
                            };
                        };
                    };
                };
                _local14++;
            };
            if (_local15){
                this.m_skinContainers.AS3::sort(compareSkinContainerSortOrder);
            };
            var _local18:int;
            _arg1.graphics.clear();
            _local14 = 0;
            while (_local14 < _local3) {
                _local7 = this.m_skinContainers[_local14];
                if (!(((((_local7.currentBitmap == null)) || (!(_local7.isVisible)))) || (!(this.joints[_local7.jointID].isVisible)))){
                    _local10 = _local7.currentBitmap;
                    _local5 = _local7.currentMat3D;
                    _local5.transformVectors(tmpData3DIn, tmpData3DOut);
                    _local4.a = (tmpData3DOut[0] - tmpData3DOut[6]);
                    _local4.b = (tmpData3DOut[1] - tmpData3DOut[7]);
                    _local4.c = (tmpData3DOut[3] - tmpData3DOut[6]);
                    _local4.d = (tmpData3DOut[4] - tmpData3DOut[7]);
                    _local4.tx = tmpData3DOut[6];
                    _local4.ty = tmpData3DOut[7];
                    if (!_arg2){
                        _local12 = _local10.width;
                        _local13 = _local10.height;
                        pathData3DIn[3] = _local12;
                        pathData3DIn[6] = _local12;
                        pathData3DIn[7] = _local13;
                        pathData3DIn[10] = _local13;
                        _local5.transformVectors(pathData3DIn, pathData3DOut);
                        pathData[0] = pathData3DOut[0];
                        pathData[1] = pathData3DOut[1];
                        pathData[2] = pathData3DOut[3];
                        pathData[3] = pathData3DOut[4];
                        pathData[4] = pathData3DOut[6];
                        pathData[5] = pathData3DOut[7];
                        pathData[6] = pathData3DOut[9];
                        pathData[7] = pathData3DOut[10];
                        _arg1.graphics.beginBitmapFill(_local10, _local4, false, true);
                        _arg1.graphics.lineStyle(0, 0, 0);
                        _arg1.graphics.drawPath(pathCommands, pathData);
                        _arg1.graphics.endFill();
                    } else {
                        if (_local18 < _arg1.numChildren){
                            _local23 = (_arg1.getChildAt(_local18) as flash.display.Bitmap);
                            _local23.bitmapData = _local10;
                            _local23.transform.matrix = _local4.clone();
                        } else {
                            _local23 = new flash.display.Bitmap(_local10, "auto", true);
                            _local23.transform.matrix = _local4.clone();
                            _arg1.addChild(_local23);
                        };
                        _local23.smoothing = true;
                        _local18++;
                    };
                };
                _local14++;
            };
            while (_local18 < _arg1.numChildren) {
                _arg1.removeChildAt((_arg1.numChildren - 1));
            };
            if (this.m_drawDebugBounds){
                if (this.m_debugSprite == null){
                    this.m_debugSprite = new flash.display.Sprite();
                };
                if (this.m_debugSprite.parent){
                    this.m_debugSprite.parent.removeChild(this.m_debugSprite);
                };
                this.m_debugSprite.graphics.clear();
                _arg1.addChild(this.m_debugSprite);
                for each (_local7 in this.m_skinContainers) {
                    if (_local7.isVisible){
                        _local6 = _local7.skinContainer;
                        if (this.joints[_local7.jointID].isVisible){
                            _local5 = _local7.currentMat3D;
                            _local10 = _local7.currentBitmap;
                            if (_local10){
                                _local5.transformVectors(tmpData3DIn, tmpData3DOut);
                                _local4.a = (tmpData3DOut[0] - tmpData3DOut[6]);
                                _local4.b = (tmpData3DOut[1] - tmpData3DOut[7]);
                                _local4.c = (tmpData3DOut[3] - tmpData3DOut[6]);
                                _local4.d = (tmpData3DOut[4] - tmpData3DOut[7]);
                                _local4.tx = tmpData3DOut[6];
                                _local4.ty = tmpData3DOut[7];
                                _local12 = _local10.width;
                                _local13 = _local10.height;
                                pathData3DIn[3] = _local12;
                                pathData3DIn[6] = _local12;
                                pathData3DIn[7] = _local13;
                                pathData3DIn[10] = _local13;
                                _local5.transformVectors(pathData3DIn, pathData3DOut);
                                pathData[0] = pathData3DOut[0];
                                pathData[1] = pathData3DOut[1];
                                pathData[2] = pathData3DOut[3];
                                pathData[3] = pathData3DOut[4];
                                pathData[4] = pathData3DOut[6];
                                pathData[5] = pathData3DOut[7];
                                pathData[6] = pathData3DOut[9];
                                pathData[7] = pathData3DOut[10];
                                pathData[8] = pathData3DOut[0];
                                pathData[9] = pathData3DOut[1];
                                this.m_debugSprite.graphics.lineStyle(1, _local7.debugDrawColor, _local7.debugDrawAlpha);
                                this.m_debugSprite.graphics.drawPath(debugPathCommands, pathData);
                            };
                        };
                    };
                };
            };
        }

    }
}//package ZDallasLib.Avatar2
