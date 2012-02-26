//Created by Action Script Viewer - http://www.buraks.com/asv
package Engine.Managers{
    import Engine.Classes.ResourceLoader;
    import Engine.Classes.URLResourceLoader;
    import Engine.Classes.ZSCILoader;
    import Engine.Events.LoaderEvent;
    
    import flash.display.Loader;
    import flash.errors.IOError;
    import flash.events.*;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.net.URLLoader;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;

    public class LoadingManager implements flash.events.IEventDispatcher {

        public static const CUT_IN_LINE:uint = 0x80000000;
        public static const PRIORITY_ULTRA:uint = 20;
        public static const PRIORITY_ULTRA_CUT_IN_LINE:uint = (PRIORITY_ULTRA | CUT_IN_LINE);
        public static const PRIORITY_HIGH:uint = 15;
        public static const PRIORITY_NORMAL:uint = 10;
        public static const PRIORITY_LOW:uint = 5;
        public static const PRIORITY_ZERO:uint = 0;

        public static var defaultContentUrl:String = "";
        public static var maxLoads:int = 12;
        public static var maxLoadsPerDomain:int = 4;
        private static var m_loadingCount:int = 0;
        private static var m_usedPriorities:Array = [];
        private static var m_loadMap:flash.utils.Dictionary = new flash.utils.Dictionary();
        private static var m_loadQueue:Array = [];
        private static var m_instance:LoadingManager;
        private static var m_outstandingRequests:flash.utils.Dictionary = new flash.utils.Dictionary();
        private static var m_domainMap:flash.utils.Dictionary = new flash.utils.Dictionary();
        private static var m_requestsStarted:int = 0;
        private static var m_requestsReceived:int = 0;
        private static var m_loadResult:flash.utils.Dictionary = new flash.utils.Dictionary();
        private static var m_bytesLoaded:Number = 0;
        private static var m_totalLoadTime:Number = 0;
        private static var m_objectsStarted:int = 0;
        private static var m_objectsLoaded:int = 0;
        private static var m_objectsFailed:int = 0;
        private static var m_queueStart:Number = 0;
        private static var m_lastQueueEmptyTime:Number = 0;
        private static var m_startedLoading:Boolean = false;
        private static var m_finishedLoading:Boolean = false;
        private static var m_lowPriorityCount:int = 0;
        private static var m_loaderCache:flash.utils.Dictionary = new flash.utils.Dictionary();
        public static var requestedAssetUrls:Array = [];
        public static var m_useZCache:Boolean = true;
        public static var m_zCacheLoader = null;

        private var m_dispatcher:flash.events.EventDispatcher = null;

        public function LoadingManager():void{
            this.m_dispatcher = new flash.events.EventDispatcher(this);
        }
        public static function loadFromUrl(_arg1:String, _arg2:Object=null){
			var _local4:*;
			var _local5:Function;
			var _local6:Function;
			var _local7:int = PRIORITY_NORMAL;
			var _local8:Boolean;
			var _local9:Boolean = true;
			var _local10:Boolean;
			//读取传入参数
			if (_arg2){
				if (_arg2.completeCallback){
					_local5 = _arg2.completeCallback;
				};
				if (_arg2.faultCallback){
					_local6 = _arg2.faultCallback;
				};
				if (_arg2.priority){
					_local7 = _arg2.priority;
				};
				if ((((_arg2.resourceLoaderClass == null)) || (!((_arg2.resourceLoaderClass is Class))))){
					_arg2.resourceLoaderClass = Engine.Classes.ResourceLoader;
				};
				if (((_arg2.AS3::hasOwnProperty("cache")) && ((_arg2.cache == false)))){
					_local9 = false;
				};
				if (_arg2.AS3::hasOwnProperty("loadImmediately")){
					_local10 = _arg2.loadImmediately;
				};
			};
			var _local13:*;
			if (_arg1.AS3::indexOf(".zsci") > -1){
				_local13 = new ZSCILoader(_arg1,_arg1,_local7,_local5,_local6);
			}else{
				_local13 = new _arg2.resourceLoaderClass(_arg1,_arg1,_local7,_local5,_local6);
			}			
			
			_local4 = _local13.getLoader();
			_local13.startLoad();
            return (_local4);
        }
		
		public function addEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false, _arg4:int=0, _arg5:Boolean=false):void{
			this.m_dispatcher.addEventListener(_arg1, _arg2, _arg3, _arg4);
		}
		public function dispatchEvent(_arg1:flash.events.Event):Boolean{
			return (this.m_dispatcher.dispatchEvent(_arg1));
		}
		public function hasEventListener(_arg1:String):Boolean{
			return (this.m_dispatcher.hasEventListener(_arg1));
		}
		public function removeEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false):void{
			this.m_dispatcher.removeEventListener(_arg1, _arg2, _arg3);
		}
		public function willTrigger(_arg1:String):Boolean{
			return (this.m_dispatcher.willTrigger(_arg1));
		}
    }
}//package Engine.Managers
