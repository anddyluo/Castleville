//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Avatar2{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class GameAnimationClipInstance implements IAnimationPlayer {

        public var fps:int = 0;
        private var m_gameAnimClip:GameAnimationClip;
        private var m_startTimeInSecs:Number;
        private var m_endTimeInSecs:Number;
        private var m_playing:Boolean = false;
        private var m_looping:Boolean = false;
        private var m_holdLastFrame:Boolean = false;
        private var m_prevTime:Number;
        private var m_prevTriggerTime:Number;
        private var m_elapsedTime:Number;
        private var m_timeSinceLastUpdate:Number = 0;
        private var m_skeleton:Skeleton;
        private var m_segments:Vector.<Number>;
        private var m_jointDataOut:Vector.<JointAnimData>;
        private var m_dynamicAttributeDataOut:Vector.<int>;
        private var m_timeScale:Number = 1;
        private var m_triggerListeners:Array;
        private var m_triggersEnabled:Boolean = true;
        private var m_hasPlayedFirstFrame:Boolean = false;
        private var m_isHolding:Boolean = false;
        private var m_njoints:uint = 0;
        private var m_nattributes:uint = 0;

        public function GameAnimationClipInstance(_arg1:GameAnimationClip, _arg2:Skeleton){
            this.m_segments = Vector.<Number>([0]);
            this.m_triggerListeners = [];
            super();
            this.m_gameAnimClip = _arg1;
            this.m_startTimeInSecs = _arg1.startTimeInSecs;
            this.m_endTimeInSecs = _arg1.endTimeInSecs;
            this.m_prevTime = this.m_startTimeInSecs;
            this.m_prevTriggerTime = this.m_startTimeInSecs;
            this.m_elapsedTime = this.m_startTimeInSecs;
            this.fps = this.m_gameAnimClip.fps;
            this.m_njoints = uint(Math.min(_arg2.numJoints, _arg1.numJoints));
            this.m_nattributes = uint(Math.min(_arg2.numDynamicAttributes, _arg1.numDynamicAttributes));
            this.m_skeleton = _arg2;
        }
        public function get name():String{
            var _local1 = "";
            if (this.m_gameAnimClip){
                _local1 = this.m_gameAnimClip.name;
            };
            return (_local1);
        }
        public function playing():Boolean{
            return (this.m_playing);
        }
        public function get timeScale():Number{
            return (this.m_timeScale);
        }
        public function set timeScale(_arg1:Number):void{
            this.m_timeScale = _arg1;
        }
        public function reset():void{
            this.m_prevTime = this.m_startTimeInSecs;
            this.m_prevTriggerTime = this.m_startTimeInSecs;
            this.m_elapsedTime = this.m_startTimeInSecs;
            this.m_timeSinceLastUpdate = 0;
            this.m_segments[0] = 0;
        }
        public function get duration():Number{
            return ((this.m_endTimeInSecs - this.m_startTimeInSecs));
        }
        public function enableTriggers():void{
            this.m_triggersEnabled = true;
        }
        public function disableTriggers():void{
            this.m_triggersEnabled = false;
        }
        public function play(_arg1:Boolean=false, _arg2:Boolean=false):void{
            this.m_playing = true;
            this.m_looping = _arg1;
            this.m_holdLastFrame = _arg2;
            this.m_hasPlayedFirstFrame = false;
            this.m_timeSinceLastUpdate = 0;
            this.m_isHolding = false;
            if (this.m_triggersEnabled){
                this.fireTriggers(true);
            };
            this.update(0);
        }
        public function stop():void{
            this.m_playing = false;
            this.m_isHolding = false;
        }
        public function dispose():void{
            this.m_segments = null;
            this.m_jointDataOut = null;
        }
        public function get isHolding():Boolean{
            return (this.m_isHolding);
        }
        public function update(_arg1:Number):Boolean{
            var _local3:Number;
            var _local4:Number;
            var _local5:Number;
            var _local6:uint;
            var _local7:uint;
            var _local2:Boolean;
            if (((this.m_playing) && (!(this.m_isHolding)))){
                _local3 = (_arg1 * this.m_timeScale);
                this.m_timeSinceLastUpdate = (this.m_timeSinceLastUpdate + _local3);
                this.m_elapsedTime = (this.m_elapsedTime + _local3);
                if (((!(this.m_looping)) && ((this.m_elapsedTime >= this.m_endTimeInSecs)))){
                    this.m_elapsedTime = this.m_endTimeInSecs;
                    this.m_isHolding = true;
                };
                if (((this.m_looping) && ((this.m_elapsedTime > this.m_endTimeInSecs)))){
                    _local4 = (this.m_elapsedTime - this.m_endTimeInSecs);
                    _local5 = (_local4 / (this.m_endTimeInSecs - this.m_startTimeInSecs));
                    this.m_elapsedTime = (this.m_startTimeInSecs + ((this.m_endTimeInSecs - this.m_startTimeInSecs) * (_local5 - int(_local5))));
                };
                if (this.m_triggersEnabled){
                    this.fireTriggers();
                };
                if (((((!(this.m_hasPlayedFirstFrame)) || (((!((this.fps == 0))) && ((this.m_timeSinceLastUpdate >= (this.m_timeScale / this.fps))))))) || (this.m_isHolding))){
                    if (this.m_prevTime > this.m_elapsedTime){
                        _local6 = this.m_segments.length;
                        _local7 = 0;
                        while (_local7 < _local6) {
                            this.m_segments[_local7] = 0;
                            _local7++;
                        };
                    };
                    if ((((this.m_elapsedTime >= this.m_startTimeInSecs)) && ((this.m_elapsedTime <= this.m_endTimeInSecs)))){
                        _local2 = this.m_gameAnimClip.evaluate(this.m_elapsedTime, this.m_segments, this.m_skeleton, this.m_njoints, this.m_nattributes, (this.m_timeScale < 1));
                        _local2 = ((_local2) || (!(this.m_hasPlayedFirstFrame)));
                    };
                    if ((((((this.m_elapsedTime >= this.m_endTimeInSecs)) && (!(this.m_looping)))) && (!(this.m_holdLastFrame)))){
                        this.stop();
                    };
                    this.m_timeSinceLastUpdate = 0;
                    this.m_prevTime = this.m_elapsedTime;
                    this.m_hasPlayedFirstFrame = true;
                };
            };
            return (_local2);
        }
        public function registerTriggerListener(_arg1:String, _arg2:String, _arg3:Function):void{
            var _local5:Object;
            var _local4:Boolean;
            for each (_local5 in this.m_triggerListeners) {
                if ((((((_local5.callback == _arg3)) && ((_local5.type == _arg1)))) && ((_local5.data == _arg2)))){
                    _local4 = true;
                    break;
                };
            };
            if (!_local4){
                this.m_triggerListeners.AS3::push({
                    type:_arg1,
                    data:_arg2,
                    callback:_arg3
                });
            };
        }
        public function unregisterTriggerListener(_arg1:String, _arg2:String, _arg3:Function):void{
            var _local5:Object;
            var _local4:uint;
            while (_local4 < this.m_triggerListeners.length) {
                _local5 = this.m_triggerListeners[_local4];
                if ((((((_local5.callback == _arg3)) && ((_local5.type == _arg1)))) && ((_local5.data == _arg2)))){
                    this.m_triggerListeners.AS3::splice(_local4, 1);
                    return;
                };
                _local4++;
            };
        }
        private function fireTriggers(_arg1:Boolean=false):void{
            var _local4:AnimationTriggerData;
            var _local5:Boolean;
            var _local6:AnimationTriggerEvent;
            var _local7:Object;
            var _local2:Vector.<AnimationTriggerData> = this.m_gameAnimClip.triggers;
            var _local3:uint;
            while (_local3 < _local2.length) {
                _local4 = _local2[_local3];
                if (_local4.time <= this.m_endTimeInSecs){
                    _local5 = (((((((this.m_prevTriggerTime > this.m_elapsedTime)) && ((((_local4.time > this.m_prevTriggerTime)) || ((_local4.time <= this.m_elapsedTime)))))) || ((((this.m_prevTriggerTime < this.m_elapsedTime)) && ((((_local4.time > this.m_prevTriggerTime)) && ((_local4.time <= this.m_elapsedTime)))))))) || (((_arg1) && ((_local4.time == this.m_elapsedTime)))));
                    if (_local5){
                        _local6 = new AnimationTriggerEvent(AnimationTriggerEvent.TRIGGER_FIRED, _local4, this);
                        for each (_local7 in this.m_triggerListeners) {
                            if ((((((_local7.type == null)) || ((_local7.type == _local4.type)))) && ((((_local7.data == null)) || ((_local7.data == _local4.data)))))){
                                (_local7.callback as Function).AS3::apply(null, [_local6]);
                            };
                        };
                        EventManager.getInstance().dispatchEvent(_local6);
                    };
                };
                _local3++;
            };
            this.m_prevTriggerTime = this.m_elapsedTime;
        }
        public function get position():Number{
            return ((this.m_elapsedTime - this.m_startTimeInSecs));
        }

    }
}//package ZDallasLib.Avatar2
