//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.ZDLocalization{
    import flash.display.Loader;
    import flash.net.URLLoader;
    import ZLocalization.Localizer;
    import flash.net.URLLoaderDataFormat;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;

    public class ZDLocaleLoader {

        private static const FONT_MAPPER_DEFINITION:String = "FontMapper";

        protected var m_Loader:flash.display.Loader;
        protected var m_urlLoader:flash.net.URLLoader;
        protected var m_localizer:ZLocalization.Localizer;
        protected var m_onComplete:Function;
        protected var m_isCompressed:Boolean;
        protected var m_loadFailed:Boolean;

        public function ZDLocaleLoader(_arg1:String, _arg2:Function, _arg3:Boolean=false){
            this.m_onComplete = _arg2;
            this.m_urlLoader = new flash.net.URLLoader();
            this.m_isCompressed = _arg3;
            if (_arg3){
                this.m_urlLoader.dataFormat = flash.net.URLLoaderDataFormat.BINARY;
            };
            this.m_urlLoader.addEventListener(flash.events.Event.COMPLETE, this.onLoadXMLComplete);
            this.m_urlLoader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onLoadXMLComplete);
            this.m_urlLoader.load(new flash.net.URLRequest(_arg1));
        }
        public function get localizer():ZLocalization.Localizer{
            return (this.m_localizer);
        }
        public function get loadFailed():Boolean{
            return (this.m_loadFailed);
        }
        protected function onLoadXMLComplete(_arg1:flash.events.Event):void{
            this.m_urlLoader.removeEventListener(flash.events.Event.COMPLETE, this.onLoadXMLComplete);
            this.m_urlLoader.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onLoadXMLComplete);
            if (!(_arg1 is flash.events.IOErrorEvent)){
                if (this.m_isCompressed){
                    this.m_urlLoader.data.uncompress();
                };
                this.m_localizer = new ZDLocalizerXML(new XML(this.m_urlLoader.data.toString()));
            } else {
                this.m_loadFailed = true;
            };
            if (this.m_onComplete != null){
                this.m_onComplete();
            };
            this.m_onComplete = null;
        }

    }
}//package ZDallasLib.ZDLocalization
