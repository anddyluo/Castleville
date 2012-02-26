//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Sound{
    import flash.events.EventDispatcher;
    import flash.utils.Timer;
    import flash.events.Event;
    import flash.events.TimerEvent;

    public class SoundSetInstance extends flash.events.EventDispatcher {

        protected var m_children:Array;
        protected var m_soundSet:SoundSet;
        protected var m_isPlaying:Boolean = false;
        protected var m_loops:int = 1;
        protected var m_volume:Number;
        protected var m_isMuted:Boolean = false;
        protected var m_delayTimer:flash.utils.Timer = null;
        protected var m_delay:Number = 0;

        public function SoundSetInstance(_arg1:Array, _arg2:SoundSet){
            this.m_children = [];
            super();
            this.m_children = _arg1;
            this.m_soundSet = _arg2;
            this.m_loops = _arg2.loops;
            this.m_delay = _arg2.delay;
            this.volume = 1;
        }
        public function pause():void{
            var _local1:Object;
            if (this.m_isPlaying){
                if (this.m_delayTimer){
                    this.m_delayTimer.stop();
                } else {
                    for each (_local1 in this.m_children) {
                        _local1.pause();
                    };
                };
                this.m_isPlaying = false;
            };
        }
        public function unpause():void{
            var _local1:Object;
            if (!this.m_isPlaying){
                if (this.m_delayTimer){
                    this.m_delayTimer.start();
                } else {
                    if (this.m_soundSet.type == "sequence"){
                        this.m_children[0].unpause();
                    } else {
                        for each (_local1 in this.m_children) {
                            _local1.unpause();
                        };
                    };
                };
                this.m_isPlaying = true;
            };
        }
        public function stop():void{
            this.m_isPlaying = false;
            while (this.m_children.length > 0) {
                this.m_children.AS3::pop().stop();
            };
            dispatchEvent(new flash.events.Event(flash.events.Event.SOUND_COMPLETE));
        }
        public function isPlaying():Boolean{
            return (this.m_isPlaying);
        }
        public function set volume(_arg1:Number):void{
            var _local2:Object;
            this.m_volume = _arg1;
            for each (_local2 in this.m_children) {
                _local2.volume = (_arg1 * this.m_soundSet.volume);
            };
        }
        public function mute():void{
            var _local1:Object;
            this.m_isMuted = true;
            for each (_local1 in this.m_children) {
                _local1.mute();
            };
        }
        public function unmute():void{
            var _local1:Object;
            for each (_local1 in this.m_children) {
                _local1.unmute();
            };
            this.m_isMuted = false;
        }
        function play():void{
            var _local1:int;
            if (this.m_delay){
                this.m_delayTimer = new flash.utils.Timer((this.m_delay * 1000), 1);
                this.m_delayTimer.addEventListener(flash.events.TimerEvent.TIMER_COMPLETE, this.onDelayTimerComplete);
                this.m_delayTimer.start();
            } else {
                if (this.m_soundSet.type == "sequence"){
                    this.playChild(0);
                } else {
                    _local1 = 0;
                    while (_local1 < this.m_children.length) {
                        this.playChild(_local1);
                        _local1++;
                    };
                };
            };
            this.m_isPlaying = true;
        }
        private function playChild(_arg1:int):void{
            var _local2:Object = this.m_children[_arg1];
            if (_local2 != null){
                _local2.addEventListener(flash.events.Event.SOUND_COMPLETE, this.onChildComplete);
                _local2.play();
                if (this.m_isMuted){
                    _local2.mute();
                };
            };
        }
        private function onLoopComplete():void{
            if (this.m_loops == 1){
                dispatchEvent(new flash.events.Event(flash.events.Event.SOUND_COMPLETE));
            } else {
                this.m_delay = this.m_soundSet.delay;
                this.m_loops = Math.max(0, (this.m_loops - 1));
                this.m_children = this.m_soundSet.createInstance().m_children;
                this.play();
            };
        }
        private function onDelayTimerComplete(_arg1:flash.events.Event):void{
            this.m_delayTimer.removeEventListener(flash.events.TimerEvent.TIMER_COMPLETE, this.onDelayTimerComplete);
            this.m_delayTimer = null;
            this.m_delay = 0;
            if (this.m_children.length == 0){
                this.onLoopComplete();
            } else {
                this.play();
            };
        }
        private function onChildComplete(_arg1:flash.events.Event):void{
            var _local2:int;
            while (_local2 < this.m_children.length) {
                if (this.m_children[_local2] == _arg1.target){
                    this.m_children[_local2].removeEventListener(flash.events.Event.SOUND_COMPLETE, this.onChildComplete);
                    this.m_children.AS3::splice(_local2, 1);
                    break;
                };
                _local2++;
            };
            if (this.m_isPlaying){
                if (this.m_children.length == 0){
                    this.onLoopComplete();
                } else {
                    if (this.m_soundSet.type == "sequence"){
                        this.playChild(0);
                    };
                };
            };
        }
        public function getSoundSet():SoundSet{
            return (this.m_soundSet);
        }
        public function isMuted():Boolean{
            return (this.m_isMuted);
        }

    }
}//package ZDallasLib.Sound
