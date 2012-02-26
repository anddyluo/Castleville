//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Sound{
    import flash.media.Sound;
    import flash.events.ProgressEvent;
    import Engine.Classes.SoundLoader;
    import flash.events.Event;

    public class SoundSet {

        protected var m_children:Array;
        protected var m_name:String = "undefined";
        protected var m_ref:String;
        protected var m_url:String;
        protected var m_volume:Number = 1;
        protected var m_type:String;
        protected var m_loops:int = 1;
        protected var m_soundManager:SoundManager;
        protected var m_isStreamable:Boolean = false;
        protected var m_delay:Number = 0;
        protected var m_weight:Number = 1;
        protected var m_childWeightTotal:Number = 0;
        protected var m_maxSoundCount:int = 0;
        protected var m_loadPriority:uint = 10;

        public function SoundSet(_arg1:XML, _arg2:SoundManager, _arg3:uint=10){
            var childSet:SoundSet;
            var childIndex:uint;
            var childSound:flash.media.Sound;
            var childDef:XML;
            var child:SoundSet;
            var xml:XML = _arg1;
            var soundManager:SoundManager = _arg2;
            var loadPriority:int = _arg3;
            this.m_children = [];
            super();
            this.m_soundManager = soundManager;
            this.m_loadPriority = loadPriority;
            if (xml.@volume != undefined){
                this.m_volume = xml.@volume;
            };
            if (xml.@type != undefined){
                this.m_type = xml.@type;
            };
            if (xml.@loops != undefined){
                this.m_loops = xml.@loops;
            };
            if (xml.@delay != undefined){
                this.m_delay = xml.@delay;
            };
            if (xml.@weight != undefined){
                this.m_weight = xml.@weight;
            };
            if (xml.@name != undefined){
                this.m_name = xml.@name;
            };
            if (xml.@ref != undefined){
                this.m_ref = xml.@ref;
                childSet = this.m_soundManager.loadSoundSet(this.m_ref, this.m_loadPriority);
                if (childSet){
                    this.m_children.AS3::push(childSet);
                };
            } else {
                if (xml.@url != undefined){
                    this.m_url = xml.@url;
                    if (xml.@isStreamable != undefined){
                        this.m_isStreamable = xml.@isStreamable;
                    };
                    if (this.m_isStreamable){
                        this.m_children.AS3::push(null);
                    } else {
                        childIndex = this.m_children.length;
                        childSound = this.m_soundManager.loadSound(this.m_url, this.m_loadPriority, function (_arg1:flash.events.Event):void{
                            _arg1.target.removeEventListener(flash.events.ProgressEvent.PROGRESS, arguments.callee);
                            onChildLoaded((_arg1.target as Engine.Classes.SoundLoader), childIndex);
                        });
                        this.m_children.AS3::push(childSound);
                    };
                } else {
                    for each (childDef in xml.sound) {
                        child = new SoundSet(childDef, this.m_soundManager, this.m_loadPriority);
                        this.m_childWeightTotal = (this.m_childWeightTotal + child.m_weight);
                        this.m_children.AS3::push(new SoundSet(childDef, this.m_soundManager, this.m_loadPriority));
                    };
                };
            };
            if (xml.@maxCount != undefined){
                this.m_maxSoundCount = int(xml.@maxCount);
            };
        }
        private function onChildLoaded(_arg1:Engine.Classes.SoundLoader, _arg2:uint):void{
            if (_arg1){
                this.m_children[_arg2] = _arg1.sound;
            };
        }
        public function isPlayable():Boolean{
            var _local1:Object;
            var _local2:flash.media.Sound;
            var _local3:Boolean;
            for each (_local1 in this.m_children) {
                if ((((_local1 == null)) || ((_local1 is flash.media.Sound)))){
                    _local2 = (_local1 as flash.media.Sound);
                    _local3 = ((this.m_isStreamable) || (((((_local2) && ((_local2.bytesTotal > 0)))) && ((_local2.bytesLoaded == _local2.bytesTotal)))));
                    if (!_local3){
                        return (false);
                    };
                } else {
                    if (!(_local1 as SoundSet).isPlayable()){
                        return (false);
                    };
                };
            };
            return (true);
        }
        public function get volume():Number{
            return (this.m_volume);
        }
        public function get loops():int{
            return (this.m_loops);
        }
        public function get type():String{
            return (this.m_type);
        }
        public function get delay():Number{
            return (this.m_delay);
        }
        function createInstance():SoundSetInstance{
            var _local2:SoundSetInstance;
            var _local3:SoundSet;
            var _local4:Number;
            var _local5:Number;
            var _local6:uint;
            var _local7:Object;
            var _local1:Array = [];
            switch (this.m_type){
                case "random":
                    if (this.m_children.length > 0){
                        _local4 = (Math.random() * this.m_childWeightTotal);
                        _local5 = 0;
                        for each (_local3 in this.m_children) {
                            _local5 = (_local5 + _local3.m_weight);
                            if (_local4 < _local5){
                                _local2 = _local3.createInstance();
                                if (_local2){
                                    _local1.AS3::push(_local2);
                                    break;
                                };
                            };
                        };
                    };
                    break;
                case "sequence":
                    for each (_local3 in this.m_children) {
                        _local2 = _local3.createInstance();
                        if (_local2){
                            _local1.AS3::push(_local2);
                        };
                    };
                    break;
                default:
                    _local6 = 0;
                    while (_local6 < this.m_children.length) {
                        _local7 = this.m_children[_local6];
                        if (_local7 == null){
                            _local1.AS3::push(new SoundInstance(null, this.m_soundManager, this.m_url, this.m_loadPriority));
                        } else {
                            if ((_local7 is flash.media.Sound)){
                                _local1.AS3::push(new SoundInstance((_local7 as flash.media.Sound)));
                            } else {
                                if ((_local7 is SoundSet)){
                                    _local2 = (_local7 as SoundSet).createInstance();
                                    if (_local2 != null){
                                        _local1.AS3::push(_local2);
                                    };
                                };
                            };
                        };
                        _local6++;
                    };
            };
            return (new SoundSetInstance(_local1, this));
        }
        public function getMaxSoundCount():int{
            return (this.m_maxSoundCount);
        }

    }
}//package ZDallasLib.Sound
