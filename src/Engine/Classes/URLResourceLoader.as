//Created by Action Script Viewer - http://www.buraks.com/asv
package Engine.Classes{
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.EventDispatcher;
    import flash.utils.ByteArray;

    public class URLResourceLoader extends ResourceLoader {

        private var m_internalLoader:flash.net.URLLoader = null;
        private var m_bytesTotal:int = 0;

        public function URLResourceLoader(_arg1:String, _arg2:String, _arg3:int=0, _arg4:Function=null, _arg5:Function=null):void{
            super(_arg1, _arg2, _arg3, _arg4, _arg5);
        }
        override protected function makeLoader():void{
            var _local1:flash.net.URLLoader = new flash.net.URLLoader();
            _local1.dataFormat = flash.net.URLLoaderDataFormat.BINARY;
            m_loader = _local1;
        }
        override public function getbytesTotal():int{
            if (this.m_internalLoader !== null){
                return (this.m_internalLoader.bytesTotal);
            };
            return (this.m_bytesTotal);
        }
        override protected function chooseLoad():void{
            this.m_bytesTotal = 0;
            this.m_internalLoader = new flash.net.URLLoader();
            this.m_internalLoader.dataFormat = flash.net.URLLoaderDataFormat.BINARY;
            this.m_internalLoader.addEventListener(flash.events.Event.COMPLETE, this.onInternalComplete);
            this.m_internalLoader.addEventListener(flash.events.HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
            this.m_internalLoader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, onError);
            this.m_internalLoader.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            this.m_internalLoader.addEventListener(flash.events.ProgressEvent.PROGRESS, onProgress);
            this.m_internalLoader.addEventListener(flash.events.Event.OPEN, onOpen);
            this.m_internalLoader.load(m_urlRequest);
        }
        override public function getEventDispatcher():flash.events.EventDispatcher{
            return (m_loader);
        }
        override protected function chooseClose():void{
            this.m_bytesTotal = this.m_internalLoader.bytesTotal;
            this.m_internalLoader.removeEventListener(flash.events.Event.COMPLETE, this.onInternalComplete);
            this.m_internalLoader.removeEventListener(flash.events.HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
            this.m_internalLoader.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, onError);
            this.m_internalLoader.removeEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            this.m_internalLoader.removeEventListener(flash.events.ProgressEvent.PROGRESS, onProgress);
            this.m_internalLoader.removeEventListener(flash.events.Event.OPEN, onOpen);
            this.m_internalLoader = null;
        }
        override protected function invokeCallback(_arg1:flash.events.Event):void{
            m_completeCallback(_arg1, m_url);
        }
        private function onInternalComplete(_arg1:flash.events.Event):void{
            var _local2:flash.net.URLLoader = (m_loader as flash.net.URLLoader);
            _local2.data = (_arg1.target.data as flash.utils.ByteArray);
            _local2.bytesLoaded = _arg1.target.bytesLoaded;
            _local2.bytesTotal = _arg1.target.bytesTotal;
            _local2.dispatchEvent(new flash.events.Event(flash.events.Event.COMPLETE));
        }

    }
}//package Engine.Classes
