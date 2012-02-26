//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Avatar2{
    import flash.events.EventDispatcher;
    import flash.net.URLLoader;
    import flash.utils.ByteArray;
    import Engine.Classes.URLResourceLoader;
    import Engine.Managers.LoadingManager;
    import flash.events.Event;
    import flash.utils.Endian;

    public class Archetype extends flash.events.EventDispatcher {

        public static const VERSION:uint = 1;

        private var m_id:String;
        private var m_loaded:Boolean = false;
        private var m_loading:Boolean = false;
        private var m_urlLoader:flash.net.URLLoader;
        private var m_skeleton:Skeleton;
        private var m_animationLibrary:AnimationLibrary;

        public function Archetype(_arg1:String){
            this.m_id = new String(_arg1);
            this.m_animationLibrary = new AnimationLibrary(this.m_id);
        }
        public function get id():String{
            return (new String(this.m_id));
        }
        public function get loaded():Boolean{
            return (this.m_loaded);
        }
        public function get loading():Boolean{
            return (this.m_loading);
        }
        public function get skeleton():Skeleton{
            return (this.m_skeleton);
        }
        public function set skeleton(_arg1:Skeleton):void{
            this.m_skeleton = _arg1;
        }
        public function get animationLibrary():AnimationLibrary{
            return (this.m_animationLibrary);
        }
        public function loadFromBytes(_arg1:flash.utils.ByteArray):void{
            var _local6:flash.utils.ByteArray;
            var _local7:String;
            var _local8:uint;
            var _local9:flash.utils.ByteArray;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            if (_local3 > 0){
                _local6 = new flash.utils.ByteArray();
                _arg1.readBytes(_local6, 0, _local3);
                this.m_skeleton = new Skeleton();
                this.m_skeleton.initSkeleton(_local6);
            };
            this.m_animationLibrary = new AnimationLibrary(this.m_id);
            var _local4:uint = _arg1.readUnsignedInt();
            var _local5:uint;
            while (_local5 < _local4) {
                _local7 = _arg1.readUTF();
                _local8 = _arg1.readUnsignedInt();
                _local9 = new flash.utils.ByteArray();
                _arg1.readBytes(_local9, 0, _local8);
                this.m_animationLibrary.addClipFromBytes(_local7, _local9);
                _local5++;
            };
            this.m_loaded = true;
            this.m_loading = false;
        }
        public function loadFromURL(_arg1:String, _arg2:uint=15):void{
            var _local3:Object = new Object();
            _local3.resourceLoaderClass = Engine.Classes.URLResourceLoader;
            _local3.priority = _arg2;
            _local3.memoryLoadCallback = this.onMemoryLoad;
            var _local4:* = Engine.Managers.LoadingManager.loadFromUrl(GlobalEngine.getAssetUrl(_arg1), _local3);
            if ((_local4 is flash.net.URLLoader)){
                this.m_urlLoader = (_local4 as flash.net.URLLoader);
                this.m_urlLoader.addEventListener(flash.events.Event.COMPLETE, this.onLoadedFromUrl);
            };
        }
        private function onMemoryLoad(_arg1:flash.utils.ByteArray):void{
            var _local2:flash.utils.ByteArray = _arg1;
            _local2.endian = flash.utils.Endian.BIG_ENDIAN;
            try {
                _local2.uncompress();
            } catch(e:Error) {
            };
            _local2.position = 0;
            this.loadFromBytes(_local2);
            this.m_loading = false;
            this.m_loaded = true;
            dispatchEvent(new flash.events.Event(flash.events.Event.COMPLETE));
        }
        private function onLoadedFromUrl(_arg1:flash.events.Event):void{
            var _local2:flash.utils.ByteArray = this.m_urlLoader.data;
            try {
                _local2.uncompress();
            } catch(e:Error) {
            };
            _local2.position = 0;
            this.loadFromBytes(_local2);
            this.m_loading = false;
            this.m_loaded = true;
            this.m_urlLoader.removeEventListener(flash.events.Event.COMPLETE, this.onLoadedFromUrl);
            this.m_urlLoader = null;
            dispatchEvent(new flash.events.Event(flash.events.Event.COMPLETE));
        }

    }
}//package ZDallasLib.Avatar2
