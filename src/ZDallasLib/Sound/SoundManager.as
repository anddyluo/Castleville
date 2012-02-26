//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Sound{
    import flash.utils.Dictionary;
    import Engine.Classes.SoundLoader;
    import flash.media.Sound;
    import Engine.Managers.LoadingManager;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class SoundManager {

        public static const CHANNEL_MUSIC:int = 0;
        public static const CHANNEL_SFX:int = 1;

        protected var m_sounds:flash.utils.Dictionary;
        protected var m_soundSets:flash.utils.Dictionary;
        protected var m_soundSetInstances:Array;
        protected var m_isMuted:Array;
        protected var m_xml:XML;
        protected var m_localAssetsPath:String;
        protected var m_liveInstances:flash.utils.Dictionary;

        public function SoundManager(_arg1:XML){
            this.m_sounds = new flash.utils.Dictionary();
            this.m_soundSets = new flash.utils.Dictionary();
            this.m_soundSetInstances = [];
            this.m_isMuted = [];
            this.m_liveInstances = new flash.utils.Dictionary();
            super();
            this.m_xml = _arg1;
        }
        public function get localAssetsPath():String{
            return (this.m_localAssetsPath);
        }
        public function set localAssetsPath(_arg1:String):void{
            this.m_localAssetsPath = _arg1;
        }
        public function loadSoundSet(_arg1:String, _arg2:uint=10):SoundSet{
            var soundSetDef:XML;
            var soundSetName:String = _arg1;
            var priority:int = _arg2;
            var soundSet:SoundSet = (this.m_soundSets[soundSetName] as SoundSet);
            if (soundSet == null){
                soundSetDef = this.m_xml.sound.(@name == soundSetName)[0];
                if (soundSetDef != null){
                    soundSet = new SoundSet(soundSetDef, this, priority);
                    this.m_soundSets[soundSetName] = soundSet;
                    this.m_liveInstances[soundSet] = 0;
                };
            };
            return (soundSet);
        }
        public function loadSound(_arg1:String, _arg2:uint=10, _arg3:Function=null, _arg4:Function=null, _arg5:Function=null):flash.media.Sound{
            var _local7:Engine.Classes.SoundLoader;
            var _local8:String;
            var _local6:flash.media.Sound = (this.m_sounds[_arg1] as flash.media.Sound);
            if (_local6 == null){
                _local7 = (this.m_sounds[_arg1] as Engine.Classes.SoundLoader);
                if (_local7 == null){
                    _local8 = ((this.m_localAssetsPath) ? (this.m_localAssetsPath + _arg1.AS3::replace(/^assets\//, "")) : GlobalEngine.getAssetUrl(_arg1));
                    _local7 = Engine.Managers.LoadingManager.loadSoundFromUrl(_local8, _arg2);
                    _local7.addEventListener(flash.events.Event.COMPLETE, this.onAssetLoadComplete);
                    this.m_sounds[_arg1] = _local7;
                };
                if (_local7){
                    if (_arg4 != null){
                        _local7.addEventListener(flash.events.Event.COMPLETE, _arg4);
                    };
                    if (_arg5 != null){
                        _local7.addEventListener(flash.events.IOErrorEvent.IO_ERROR, _arg5);
                    };
                    if (_arg3 != null){
                        _local7.addEventListener(flash.events.ProgressEvent.PROGRESS, _arg3);
                    };
                };
            };
            return (_local6);
        }
        public function playSoundSet(_arg1:String, _arg2:int=1):SoundSetInstance{
            var _local3:SoundSet = this.m_soundSets[_arg1];
            var _local4:SoundSetInstance;
            var _local5:int;
            var _local6:int;
            if (_local3 == null){
                _local3 = this.loadSoundSet(_arg1);
            };
            if (((!((_local3 == null))) && (_local3.isPlayable()))){
                _local6 = _local3.getMaxSoundCount();
                _local5 = int(this.m_liveInstances[_local3]);
                if ((((_local6 == 0)) || ((_local5 < _local6)))){
                    _local4 = _local3.createInstance();
                    if (_local4 != null){
                        if (this.m_isMuted[_arg2]){
                            _local4.mute();
                        };
                        if (_local6 > 0){
                            this.m_liveInstances[_local3] = (int(this.m_liveInstances[_local3]) + 1);
                        };
                        this.m_soundSetInstances.AS3::push({
                            instance:_local4,
                            channel:_arg2
                        });
                        _local4.addEventListener(flash.events.Event.SOUND_COMPLETE, this.onSoundSetInstanceComplete);
                        _local4.play();
                    };
                };
            };
            return (_local4);
        }
        public function mute(_arg1:int=-1):void{
            var _local2:Object;
            if ((((_arg1 == -1)) || ((_arg1 == CHANNEL_MUSIC)))){
                this.m_isMuted[CHANNEL_MUSIC] = true;
            };
            if ((((_arg1 == -1)) || ((_arg1 == CHANNEL_SFX)))){
                this.m_isMuted[CHANNEL_SFX] = true;
            };
            for each (_local2 in this.m_soundSetInstances) {
                if ((((_arg1 == -1)) || ((_local2.channel == _arg1)))){
                    _local2.instance.mute();
                };
            };
        }
        public function unmute(_arg1:int=-1):void{
            var _local2:Object;
            if ((((_arg1 == -1)) || ((_arg1 == CHANNEL_MUSIC)))){
                this.m_isMuted[CHANNEL_MUSIC] = false;
            };
            if ((((_arg1 == -1)) || ((_arg1 == CHANNEL_SFX)))){
                this.m_isMuted[CHANNEL_SFX] = false;
            };
            for each (_local2 in this.m_soundSetInstances) {
                if ((((_arg1 == -1)) || ((_local2.channel == _arg1)))){
                    _local2.instance.unmute();
                };
            };
        }
        public function stopAllSoundSets(_arg1:int=-1):void{
            var _local3:Object;
            var _local4:SoundSetInstance;
            var _local2:Array = [];
            for each (_local3 in this.m_soundSetInstances) {
                if ((((_arg1 == -1)) || ((_local3.channel == _arg1)))){
                    _local2.AS3::push(_local3.instance);
                };
            };
            for each (_local4 in _local2) {
                _local4.stop();
            };
        }
        public function soundSetNames():Vector.<String>{
            var _local2:String;
            var _local1:Vector.<String> = new Vector.<String>();
            for (_local2 in this.m_soundSets) {
                _local1.AS3::push(_local2);
            };
            return (_local1);
        }
        protected function onAssetLoadComplete(_arg1:flash.events.Event):void{
            var _local3:String;
            var _local2:Engine.Classes.SoundLoader = (_arg1.target as Engine.Classes.SoundLoader);
            for (_local3 in this.m_sounds) {
                if (this.m_sounds[_local3] == _local2){
                    this.m_sounds[_local3] = _local2.sound;
                };
            };
        }
        protected function onAssetLoadIOError(_arg1:flash.events.Event):void{
        }
        protected function onSoundSetInstanceComplete(_arg1:flash.events.Event):void{
            var _local2:SoundSetInstance = (_arg1.target as SoundSetInstance);
            var _local3:int;
            while (_local3 < this.m_soundSetInstances.length) {
                if (this.m_soundSetInstances[_local3].instance == _local2){
                    this.m_soundSetInstances.AS3::splice(_local3, 1);
                    if (this.m_liveInstances[_local2.getSoundSet()]){
                        this.m_liveInstances[_local2.getSoundSet()] = Math.max(0, (this.m_liveInstances[_local2.getSoundSet()] - 1));
                    };
                    return;
                };
                _local3++;
            };
        }

    }
}//package ZDallasLib.Sound
