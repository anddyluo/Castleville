//Created by Action Script Viewer - http://www.buraks.com/asv
package Engine.Classes{
    import flash.events.EventDispatcher;
    import flash.net.URLRequest;
    import flash.system.LoaderContext;
    import flash.utils.Timer;
    import com.adobe.net.URI;
    import flash.system.Security;
    import flash.system.SecurityDomain;
    import flash.system.ApplicationDomain;
    import flash.events.HTTPStatusEvent;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.ProgressEvent;
    import flash.display.Loader;
    import flash.events.TimerEvent;
    import Engine.Managers.ErrorManager;
    import flash.events.*;

    public class ResourceLoader implements flash.events.IEventDispatcher {

        private static const MAX_RETRIES:int = 2;
        private static const TIMEOUT_LENGTH:Number = 15000;

        private var m_retryCount:int = 0;
        protected var m_url:String = null;
        protected var m_rawUrl:String = null;
        private var m_trackStatus:Boolean = true;
        private var m_domain:String = null;
        private var m_priority:int = 0;
        protected var m_loader:flash.events.EventDispatcher = null;
        protected var m_completeCallback:Function = null;
        private var m_faultCallback:Function = null;
        protected var m_urlRequest:flash.net.URLRequest = null;
        private var m_context:flash.system.LoaderContext = null;
        private var m_dispatcher:flash.events.EventDispatcher = null;
        private var m_dispatchedEvent:Boolean = false;
        private var m_timeoutTimer:flash.utils.Timer;
        private var m_receivedBytes:Boolean = false;
        private var m_loadStarted:Boolean = false;
        private var m_loadStartTime:Number = 0;
        private var m_loadTime:Number = 0;

        public function ResourceLoader(_arg1:String, _arg2:String, _arg3:int=0, _arg4:Function=null, _arg5:Function=null, _arg6:Boolean=false){
            var _local7:com.adobe.net.URI;
            super();
            if (!_arg6){
                _local7 = new com.adobe.net.URI(_arg2);
                this.m_domain = _local7.authority;
            };
            this.m_dispatcher = new flash.events.EventDispatcher(this);
            this.m_url = _arg2;
            this.m_rawUrl = _arg1;
            this.m_priority = _arg3;
            this.m_completeCallback = _arg4;
            this.m_faultCallback = _arg5;
            this.makeLoader();
            this.registerLoadEventHandlers();
            try {
                flash.system.Security.allowDomain("*.zynga.com");
            } catch(error:SecurityError) {
            };
            this.m_context = new flash.system.LoaderContext();
            if (flash.system.Security.sandboxType == flash.system.Security.REMOTE){
                this.m_context.securityDomain = flash.system.SecurityDomain.currentDomain;
            };
            this.m_context.applicationDomain = flash.system.ApplicationDomain.currentDomain;
            this.m_context.checkPolicyFile = true;
            if (!_arg6){
                this.m_urlRequest = new flash.net.URLRequest(_arg2);
            };
        }
        protected function registerLoadEventHandlers():void{
            var _local1:flash.events.EventDispatcher = this.getEventDispatcher();
            _local1.addEventListener(flash.events.HTTPStatusEvent.HTTP_STATUS, this.onHTTPStatus);
            _local1.addEventListener(flash.events.Event.COMPLETE, this.onComplete);
            _local1.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onError);
            _local1.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
            _local1.addEventListener(flash.events.ProgressEvent.PROGRESS, this.onProgress);
            _local1.addEventListener(flash.events.Event.OPEN, this.onOpen);
        }
        protected function cleanupLoadEventHandlers():void{
            var _local1:flash.events.EventDispatcher = this.getEventDispatcher();
            _local1.removeEventListener(flash.events.HTTPStatusEvent.HTTP_STATUS, this.onHTTPStatus);
            _local1.removeEventListener(flash.events.Event.COMPLETE, this.onComplete);
            _local1.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onError);
            _local1.removeEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
            _local1.removeEventListener(flash.events.ProgressEvent.PROGRESS, this.onProgress);
            _local1.removeEventListener(flash.events.Event.OPEN, this.onOpen);
        }
        protected function makeLoader():void{
            var _local1:flash.display.Loader = new flash.display.Loader();
            this.m_loader = _local1;
        }
        public function getLoader():flash.events.EventDispatcher{
            return (this.m_loader);
        }
        public function getPriority():Number{
            return (this.m_priority);
        }
        public function disableStatusTracking():void{
            this.m_trackStatus = false;
        }
        public function statusTrackingEnabled():Boolean{
            return (this.m_trackStatus);
        }
        public function getDomain():String{
            return (this.m_domain);
        }
        public function getURL():String{
            return (this.m_url);
        }
        public function getRawUrl():String{
            return (this.m_rawUrl);
        }
        public function getbytesTotal():int{
            return ((this.m_loader as flash.display.Loader).contentLoaderInfo.bytesTotal);
        }
        public function getEventDispatcher():flash.events.EventDispatcher{
            return ((this.m_loader as flash.display.Loader).contentLoaderInfo);
        }
        public function startLoad():void{
            if (this.m_loadStarted){
                this.resetLoader();
            };
            this.m_loadStarted = true;
            try {
                this.chooseLoad();
                this.m_timeoutTimer = new flash.utils.Timer(TIMEOUT_LENGTH);
                this.m_timeoutTimer.addEventListener(flash.events.TimerEvent.TIMER, this.onTimeout);
                this.m_timeoutTimer.start();
//                this.m_loadStartTime = GlobalEngine.currentTime;
                this.m_loadTime = 0;
            } catch(error:Error) {
                GlobalEngine.log("Loader", ((("Start load error: " + m_url) + " : ") + error.toString()));
                dispatchFault(new flash.events.IOErrorEvent(flash.events.IOErrorEvent.IO_ERROR, false, false, "ResourceLoader Dispatched IOError Event"), Engine.Managers.ErrorManager.ERROR_FAILED_TO_LOAD);
            };
        }
        protected function chooseLoad():void{
            (this.m_loader as flash.display.Loader).load(this.m_urlRequest, this.m_context);
        }
        protected function chooseClose():void{
            (this.m_loader as flash.display.Loader).close();
        }
        public function stopLoad():void{
            this.stopTimeoutTimer();
            if (this.m_loader != null){
                this.removeEventListeners();
                this.m_dispatchedEvent = true;
                try {
                    this.chooseClose();
                } catch(error:Error) {
                };
            };
        }
        protected function resetLoader():void{
            this.m_dispatchedEvent = false;
            this.m_loadStarted = false;
            this.removeEventListeners();
            try {
                this.chooseClose();
            } catch(error:Error) {
            };
            this.registerLoadEventHandlers();
        }
        protected function onOpen(_arg1:flash.events.Event):void{
            GlobalEngine.log("Loader", ("Start load: " + this.m_url));
            this.stopTimeoutTimer();
        }
        private function stopTimeoutTimer():void{
            if (this.m_timeoutTimer){
                this.m_timeoutTimer.stop();
                this.m_timeoutTimer.removeEventListener(flash.events.TimerEvent.TIMER, this.onTimeout);
                this.m_timeoutTimer = null;
            };
        }
        private function onTimeout(_arg1:flash.events.Event):void{
            this.stopTimeoutTimer();
            if (this.m_dispatchedEvent == false){
                GlobalEngine.log("Loader", ((("Load timed out (try: " + this.m_retryCount) + "): ") + this.m_url));
            };
            if (this.m_retryCount == MAX_RETRIES){
                this.dispatchFault(_arg1, Engine.Managers.ErrorManager.ERROR_LOAD_TIMED_OUT);
            } else {
                this.m_retryCount++;
                this.startLoad();
            };
        }
        protected function onComplete(_arg1:flash.events.Event):void{
            this.stopTimeoutTimer();
            if (this.m_dispatchedEvent == false){
                this.m_loadTime = ((GlobalEngine.currentTime - this.m_loadStartTime) / 1000);
                this.dispatchEvent(new flash.events.Event(flash.events.Event.COMPLETE));
                if (this.m_completeCallback != null){
                    this.invokeCallback(_arg1);
                    this.m_completeCallback = null;
                };
                this.m_dispatchedEvent = true;
                this.removeEventListeners();
            };
        }
        public function getFinalLoadTime():Number{
            return (this.m_loadTime);
        }
        protected function invokeCallback(_arg1:flash.events.Event):void{
            this.m_completeCallback(_arg1);
        }
        protected function onProgress(_arg1:flash.events.ProgressEvent):void{
            this.m_receivedBytes = true;
            this.stopTimeoutTimer();
        }
        protected function dispatchFault(_arg1:flash.events.Event, _arg2:int, _arg3:Object=null):void{
            this.stopTimeoutTimer();
            if (this.m_dispatchedEvent == false){
                this.dispatchEvent(new flash.events.IOErrorEvent(flash.events.IOErrorEvent.IO_ERROR, false, false, "ResourceLoader Dispatched IOError Event"));
                Engine.Managers.ErrorManager.addError(this.m_url, _arg2, _arg3);
                if (this.m_faultCallback != null){
                    this.m_faultCallback(_arg1);
                };
                this.m_dispatchedEvent = true;
            };
        }
        protected function onError(_arg1:flash.events.IOErrorEvent):void{
            this.stopTimeoutTimer();
            if (this.m_dispatchedEvent == false){
                GlobalEngine.log("Loader", ((("Load error (try: " + this.m_retryCount) + "): ") + this.m_url));
            };
            if (this.m_retryCount == MAX_RETRIES){
                this.dispatchFault(_arg1, Engine.Managers.ErrorManager.ERROR_LOAD_IO_ERROR);
            } else {
                this.m_retryCount++;
                this.startLoad();
            };
        }
        protected function onSecurityError(_arg1:flash.events.SecurityErrorEvent):void{
            if (this.m_dispatchedEvent == false){
                this.stopTimeoutTimer();
                if (this.m_dispatchedEvent == false){
                    GlobalEngine.log("Loader", ((("Security Load error (try: " + this.m_retryCount) + "): ") + this.m_url));
                };
                if (this.m_retryCount == MAX_RETRIES){
                    this.dispatchFault(_arg1, Engine.Managers.ErrorManager.ERROR_LOAD_SECURITY_ERROR);
                } else {
                    this.m_retryCount++;
                    this.startLoad();
                };
            };
        }
        protected function onHTTPStatus(_arg1:flash.events.HTTPStatusEvent):void{
            if ((((((_arg1.status > 0)) && (!((_arg1.status == 200))))) && ((this.m_dispatchedEvent == false)))){
                if (this.m_dispatchedEvent == false){
                    GlobalEngine.log("Loader", ((((("HTTP Status error (code: " + _arg1.status) + ", try: ") + this.m_retryCount) + "): ") + this.m_url));
                };
                this.dispatchFault(_arg1, Engine.Managers.ErrorManager.ERROR_LOAD_HTTP_ERROR, {status:_arg1.status});
            };
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
        private function removeEventListeners():void{
            var _local1:flash.events.EventDispatcher = this.getEventDispatcher();
            _local1.removeEventListener(flash.events.HTTPStatusEvent.HTTP_STATUS, this.onHTTPStatus);
            _local1.removeEventListener(flash.events.Event.COMPLETE, this.onComplete);
            _local1.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onError);
            _local1.removeEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
            _local1.removeEventListener(flash.events.ProgressEvent.PROGRESS, this.onProgress);
            _local1.removeEventListener(flash.events.Event.OPEN, this.onOpen);
        }

    }
}//package Engine.Classes
