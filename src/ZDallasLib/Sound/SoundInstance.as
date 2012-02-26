//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Sound{
    import flash.events.EventDispatcher;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import ZDallasLib.Sound.SoundManager;
    import flash.events.Event;
    import Engine.Classes.SoundLoader;
    import flash.events.ProgressEvent;
    import flash.media.SoundTransform;

    class SoundInstance extends flash.events.EventDispatcher {

        protected var m_sound:flash.media.Sound;
        protected var m_soundChannel:flash.media.SoundChannel;
        protected var m_position:Number = 0;
        protected var m_volume:Number = 1;
        protected var m_muted:Boolean = false;
        protected var m_url:String;
        protected var m_loadPriority:int;
        protected var m_soundManager:ZDallasLib.Sound.SoundManager;

        public function SoundInstance(_arg1:flash.media.Sound, _arg2:ZDallasLib.Sound.SoundManager=null, _arg3:String=null, _arg4:uint=10){
            this.m_sound = _arg1;
            this.m_url = _arg3;
            this.m_loadPriority = _arg4;
            this.m_soundManager = _arg2;
        }
        public function pause():void{
            if (this.m_sound){
                this.m_sound.removeEventListener(flash.events.Event.OPEN, this.onProgressPlay);
                if (this.m_soundChannel != null){
                    this.m_position = this.m_soundChannel.position;
                    this.m_soundChannel.stop();
                    this.m_soundChannel = null;
                };
            };
        }
        public function unpause():void{
            this.play();
        }
        public function play():void{
            if (this.m_soundChannel == null){
                if ((((this.m_sound == null)) && (!((this.m_url == null))))){
                    this.m_sound = this.m_soundManager.loadSound(this.m_url, this.m_loadPriority, this.onProgressPlay);
                };
                if (this.m_sound){
                    this.onProgressPlay();
                };
            };
        }
        private function onProgressPlay(_arg1:flash.events.Event=null):void{
            var _local2:Engine.Classes.SoundLoader;
            if (_arg1){
                _local2 = (_arg1.target as Engine.Classes.SoundLoader);
                if (_local2){
                    this.m_sound = _local2.sound;
                    _local2.removeEventListener(flash.events.ProgressEvent.PROGRESS, this.onProgressPlay);
                };
            };
            if (this.m_sound){
                this.m_soundChannel = this.m_sound.play(this.m_position, 0, new flash.media.SoundTransform(((this.m_muted) ? 0 : this.m_volume), 0));
                if (this.m_soundChannel){
                    this.m_soundChannel.addEventListener(flash.events.Event.SOUND_COMPLETE, this.onSoundComplete);
                } else {
                    this.onSoundComplete();
                };
            };
        }
        public function stop():void{
            if (this.m_sound){
                this.m_sound.removeEventListener(flash.events.ProgressEvent.PROGRESS, this.onProgressPlay);
                if (this.m_soundChannel != null){
                    this.m_position = 0;
                    this.m_soundChannel.stop();
                    this.m_soundChannel = null;
                };
            };
        }
        public function set volume(_arg1:Number):void{
            this.m_volume = _arg1;
            if (this.m_soundChannel != null){
                this.m_soundChannel.soundTransform = new flash.media.SoundTransform(this.m_volume, this.m_soundChannel.soundTransform.pan);
                this.m_soundChannel.soundTransform.volume = this.m_volume;
            };
        }
        public function mute():void{
            this.m_muted = true;
            if (this.m_soundChannel != null){
                this.m_soundChannel.soundTransform = new flash.media.SoundTransform(0, this.m_soundChannel.soundTransform.pan);
            };
        }
        public function unmute():void{
            this.m_muted = false;
            if (this.m_soundChannel != null){
                this.m_soundChannel.soundTransform = new flash.media.SoundTransform(this.m_volume, this.m_soundChannel.soundTransform.pan);
            };
        }
        private function onSoundComplete(_arg1:flash.events.Event=null):void{
            this.m_position = 0;
            this.m_soundChannel = null;
            dispatchEvent(new flash.events.Event(flash.events.Event.SOUND_COMPLETE));
        }

    }
}//package ZDallasLib.Sound
