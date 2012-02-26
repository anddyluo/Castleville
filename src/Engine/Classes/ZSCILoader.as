//Created by Action Script Viewer - http://www.buraks.com/asv
package Engine.Classes{
    import flash.events.Event;
    import flash.display.Loader;
    import Engine.Managers.LoadingManager;
    import flash.events.IOErrorEvent;
    import flash.events.EventDispatcher;
    import flash.display.Bitmap;

    public class ZSCILoader extends ResourceLoader {

        private var m_urlResourceLoader:URLResourceLoader;
        private var m_zsci:ZSCI = null;
        private var m_postLoadFaultCallback:Function;

        public function ZSCILoader(_arg1:String, _arg2:String, _arg3:int=0, _arg4:Function=null, _arg5:Function=null):void{
            super(_arg1, _arg2, _arg3, _arg4, _arg5, true);
            this.m_postLoadFaultCallback = _arg5;
        }
        public function onURLComplete(_arg1:flash.events.Event):void{
        }
        public function onURLError(_arg1:flash.events.Event):void{
        }
        public function finishedUrlLoad(_arg1:flash.events.Event, _arg2:String):void{
            this.m_zsci = new ZSCI(_arg1.currentTarget.data);
            (m_loader as flash.display.Loader).contentLoaderInfo.addEventListener(flash.events.Event.INIT, this.onComplete);
            (m_loader as flash.display.Loader).loadBytes(this.m_zsci.getJpegData());
            this.m_zsci.decompressAlpha();
        }
        public function failedUrlLoad(_arg1:flash.events.Event):void{
            if (this.m_postLoadFaultCallback != null){
                this.m_postLoadFaultCallback(_arg1);
            };
        }
        override protected function makeLoader():void{
            var _local1:flash.display.Loader = new flash.display.Loader();
            m_loader = _local1;
        }
        override public function getbytesTotal():int{
            return ((m_loader as flash.display.Loader).contentLoaderInfo.bytesTotal);
        }
        override protected function chooseLoad():void{
            if (this.m_urlResourceLoader){
                this.m_urlResourceLoader.stopLoad();
            };
            this.m_urlResourceLoader = new URLResourceLoader(m_rawUrl, m_url, Engine.Managers.LoadingManager.PRIORITY_HIGH, this.finishedUrlLoad, this.failedUrlLoad);
            this.m_urlResourceLoader.addEventListener(flash.events.Event.COMPLETE, this.onURLComplete, false, 0, true);
            this.m_urlResourceLoader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onURLError, false, 0, true);
            this.m_urlResourceLoader.startLoad();
        }
        override public function getEventDispatcher():flash.events.EventDispatcher{
            return (m_loader);
        }
        override protected function chooseClose():void{
            (m_loader as flash.display.Loader).close();
        }
        override protected function onComplete(_arg1:flash.events.Event):void{
            var _local2:flash.display.Bitmap = ((m_loader as flash.display.Loader).content as flash.display.Bitmap);
            _local2.bitmapData = this.m_zsci.decodeAlpha(_local2);
            super.onComplete(_arg1);
            this.m_zsci = null;
        }

    }
}//package Engine.Classes
