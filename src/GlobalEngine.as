//Created by Action Script Viewer - http://www.buraks.com/asv
package {
    import flash.display.StageQuality;
    import flash.display.Stage;
//    import Engine.Classes.Viewport;
//    import Engine.Classes.SocialNetwork;
    import flash.utils.Timer;
//    import Engine.Classes.ZEngineOptions;
//    import Engine.Init.InitializationManager;
//    import Engine.Managers.ZaspManager;
//    import Engine.Interfaces.ILocalizer;
//    import Engine.Interfaces.IFontMapper;
//    import Engine.Classes.DefaultFontMapper;
    import flash.utils.getTimer;
//    import Engine.Managers.LocalizationManager;
//    import Engine.Managers.TransactionManager;
    import flash.media.SoundMixer;
    import flash.media.SoundTransform;
    import com.adobe.utils.StringUtil;
//    import Engine.Zimfs.ZimfsLoader;
    import flash.external.ExternalInterface;
    import flash.debugger.enterDebugger;

    public class GlobalEngine {

        public static const STAGE_QUALITY_LOW:String = flash.display.StageQuality.LOW.AS3::toUpperCase();
        public static const STAGE_QUALITY_HIGH:String = flash.display.StageQuality.HIGH.AS3::toUpperCase();
        public static const LEVEL_ERROR:int = 1;
        public static const LEVEL_WARNING:int = 2;
        public static const LEVEL_INFO:int = 3;
        public static const LEVEL_ALL:int = LEVEL_INFO;//3
        public static const LEVEL_NONE:int = -1;

        public static var stage:flash.display.Stage = null;
//        public static var viewport:Engine.Classes.Viewport;
//        public static var socialNetwork:Engine.Classes.SocialNetwork;
        public static var onFeedCloseCallback:Function = null;
        public static var feedCallbackTimer:flash.utils.Timer = null;
//        public static var engineOptions:Engine.Classes.ZEngineOptions = null;
//        public static var initializationManager:Engine.Init.InitializationManager;
//        public static var zaspManager:Engine.Managers.ZaspManager;
        public static var lastInputTick:int = 0;
        protected static var m_internalServerTime:Number = 0;
        protected static var m_currentTime:int;
        protected static var m_currentGetTimerCached:Number = 0;
        protected static var m_syncTime:Number = 0;
        protected static var m_flashVars:Object = null;
        protected static var m_startingWaitTime:Number = 0;
        protected static var m_zyParams:Object = null;
//        private static var m_localizer:Engine.Interfaces.ILocalizer = null;
//        private static var m_fontMapper:Engine.Interfaces.IFontMapper = new Engine.Classes.DefaultFontMapper();
        public static var CurrentFrameNumber:uint = 0;
        private static var stc_stackCache:Object = {};

        public static function updateTimers():void{
            m_currentTime = flash.utils.getTimer();
            m_currentGetTimerCached = ((m_currentTime - m_syncTime) + (m_internalServerTime * 1000));
        }
        public static function setInternalServerTime(_arg1:Number):void{
            m_internalServerTime = _arg1;
            m_syncTime = flash.utils.getTimer();
            updateTimers();
        }
        public static function get serverTime():Number{
            return (((m_currentTime - m_syncTime) + (m_internalServerTime * 1000)));
        }
        public static function get currentTime():int{
            return (m_currentTime);
        }
        public static function get startingWaitTime():Number{
            return (m_startingWaitTime);
        }
        public static function setStartingWaitTime():void{
            m_startingWaitTime = (m_currentTime / 1000);
        }
        public static function isServerTimeValid():Boolean{
            return (!((m_internalServerTime == 0)));
        }
//        public static function set localizer(_arg1:Engine.Interfaces.ILocalizer):void{
//            m_localizer = _arg1;
//        }
//        public static function get localizer():Engine.Interfaces.ILocalizer{
//            return (m_localizer);
//        }
        public static function quickLocalize(_arg1:String, _arg2:String=null, _arg3:Array=null, _arg4:Boolean=true):String{
            var _local6:Array;
            if (_arg2 == null){
                _local6 = _arg1.AS3::split(":");
                if (_local6.length == 2){
                    _arg1 = _local6[0];
                    _arg2 = _local6[1];
                };
            };
            var _local5:String ="";//= Engine.Managers.LocalizationManager.quickLocalize(_arg1, _arg2, _arg3);
            if (_arg4){
                if (_local5 == null){
                    _local5 = "";
                };
                if (_local5 == ""){
                    _local5 = (((_arg1 + ".props: ") + _arg2) + "=??");
                };
                if (_local5 == "null"){
                    _local5 = "";
                };
            };
            return (_local5);
        }
//        public static function set fontMapper(_arg1:Engine.Interfaces.IFontMapper):void{
//            m_fontMapper = _arg1;
//        }
//        public static function get fontMapper():Engine.Interfaces.IFontMapper{
//            return (m_fontMapper);
//        }
        public static function getTimer():Number{
            return (m_currentGetTimerCached);
        }
        public static function getCurrentTime():Number{
            return (((m_currentTime + m_syncTime) + (m_internalServerTime * 1000)));
        }
        public static function getTimerInSeconds():Number{
            return (Math.floor((m_currentGetTimerCached / 1000)));
        }
        public static function get zyParams():Object{
            var _local1:Object;
            var _local2:String;
            if (GlobalEngine.m_zyParams == null){
                _local1 = {};
                for (_local2 in m_flashVars) {
                    if (_local2.AS3::substr(0, 2) == "zy"){
                        _local1[_local2] = m_flashVars[_local2];
                    };
                };
                GlobalEngine.m_zyParams = _local1;
            };
            return (GlobalEngine.m_zyParams);
        }
        public static function set zyParams(_arg1:Object):void{
            GlobalEngine.m_zyParams = _arg1;
//            Engine.Managers.TransactionManager.additionalSignedParams = _arg1;
        }
        public static function getFlashVars():Object{
            return (m_flashVars);
        }
        public static function parseFlashVars(_arg1:Object):void{
            m_flashVars = _arg1;
            if (_arg1.noSound == 1){
                flash.media.SoundMixer.soundTransform = new flash.media.SoundTransform(0);
            };
            if (_arg1.app_url != null){
                Config.BASE_PATH = _arg1.app_url;
                Config.SERVICES_GATEWAY_PATH = (_arg1.app_url + "flashservices/gateway.php");
                Config.RECORD_STATS_PATH = (_arg1.app_url + "record_stats.php");
            };
            if (_arg1.sn_app_url != null){
                Config.SN_APP_URL = _arg1.sn_app_url;
            };
            if (((!((_arg1.additional_asset_urls == null))) || (!((_arg1.asset_url == null))))){
                setAssetUrls(_arg1.asset_url, _arg1.additional_asset_urls);
            };
            if (_arg1.serverTime != null){
                GlobalEngine.setInternalServerTime(_arg1.serverTime);
            };
            if (((_arg1.is_admin) && ((_arg1.is_admin == "true")))){
                Config.IS_ADMIN = true;
            };
            if ((((Config.IS_ADMIN == true)) && ((_arg1.debugMode == 1)))){
                Config.DEBUG_MODE = true;
            };
            if (_arg1.loadConfigLocally == 1){
                Config.LOAD_CONFIG_LOCALLY = true;
            };
            if (_arg1.loadAssetsLocally == 1){
                Config.LOAD_ASSETS_LOCALLY = true;
            };
            if (_arg1.logAssetRequests == 1){
                Config.LOG_ASSET_REQUESTS = true;
            };
        }
        public static function getFlashVar(_arg1:String):Object{
            return (m_flashVars[_arg1]);
        }
        public static function error(_arg1:String, _arg2:String):void{
            logByLevel(LEVEL_ERROR, _arg1, _arg2);
        }
        public static function warning(_arg1:String, _arg2:String):void{
            logByLevel(LEVEL_WARNING, _arg1, _arg2);
        }
        public static function log(_arg1:String, _arg2:String):void{
            logByLevel(LEVEL_INFO, _arg1, _arg2);
        }
        public static function info(_arg1:String, _arg2:String):void{
            logByLevel(LEVEL_INFO, _arg1, _arg2);
        }
        public static function msg(... _args):void{
            logByLevel(LEVEL_INFO, null, _args.AS3::join(" "));
        }
        private static function logByLevel(_arg1:int, _arg2:String, _arg3:String):void{
            var _local4:Object;
            var _local5:int;
            var _local6:String;
            if (Config.verboseLogging){
                if ((((null == _arg2)) || ((_arg1 <= LEVEL_WARNING)))){
                    _local4 = computeSectionFromStack();
                };
                if (null == _arg2){
                    _arg2 = _local4.sectionName;
                };
//                _local5 = Config.TRACE_DEFAULT_LEVEL;
                if (((!((null == Config.TRACE_SECTIONS))) && ((_arg1 >= LEVEL_INFO)))){
                    if (Config.TRACE_SECTIONS.AS3::hasOwnProperty(_arg2)){
                        _local5 = Config.TRACE_SECTIONS[_arg2];
                    };
                };
                if (_arg1 <= _local5){
                    _local6 = (((("" + dateToShortTime(new Date())) + " ") + _arg2) + ": ");
                    if (LEVEL_ERROR == _arg1){
                        _local6 = (_local6 + ((("**ERROR** " + _arg3) + "\r\n") + _local4.stackTrace));
                    } else {
                        if (LEVEL_WARNING == _arg1){
                            _local6 = (_local6 + ("**WARNING** " + _arg3));
                        } else {
                            _local6 = (_local6 + _arg3);
                        };
                    };
                    trace(_local6);
                };
            };
        }
        private static function computeSectionFromStack():Object{
            var _local5:Object;
            var _local6:Array;
            var _local7:String;
            var _local8:String;
            var _local9:Array;
            var _local10:int;
            var _local11:RegExp;
            var _local12:Object;
            var _local1:String;
            var _local2:Object = {
                stackTrace:"",
                rawLine:"",
                packageName:"",
                className:"",
                methodName:"<unknown>",
                fileName:"",
                lineNumber:0
            };
            var _local3:Error = new Error();
            var _local4:int = 5;
            _local1 = _local3.getStackTrace();
            if (((!((_local1 == null))) && (!((_local1 == ""))))){
                _local5 = stc_stackCache[_local1];
                if (null == _local5){
                    _local6 = _local1.AS3::split("\n");
                    if (_local6.length >= _local4){
                        _local2.stackTrace = _local6.AS3::slice((_local4 - 1)).AS3::join("\r\n");
                        _local7 = String(_local6[(_local4 - 1)]);
                        _local2.rawLine = com.adobe.utils.StringUtil.ltrim(_local7);
                        _local8 = _local7.AS3::substring(4, _local7.AS3::indexOf("()", 4));
                        _local10 = _local8.AS3::indexOf("::");
                        if (-1 != _local10){
                            _local2.packageName = _local8.AS3::substr(0, _local10);
                            _local8 = _local8.AS3::substr((_local10 + 2));
                        };
                        _local11 = /\[(.*):(\d+)\]/i;
                        _local12 = _local11.AS3::exec(_local7);
                        if (_local12){
                            _local2.fileName = _local12[1];
                            _local2.lineNumber = _local12[2];
                        };
                        if (-1 != _local8.AS3::indexOf("$/")){
                            _local9 = _local8.AS3::split("$/", 2);
                            _local2.className = _local9[0];
                            _local2.methodName = _local9[1];
                        } else {
                            _local10 = _local8.AS3::indexOf("/");
                            if (-1 != _local10){
                                _local9 = _local8.AS3::split("/", 2);
                                _local2.className = _local9[0];
                                _local2.methodName = _local9[1];
                            } else {
                                _local2.className = _local8;
                                _local2.methodName = "ctor";
                            };
                        };
                    };
                    if (_local2.className == "global"){
                        _local2.sectionName = _local2.methodName;
                    } else {
                        _local2.sectionName = _local2.className;
                    };
                    stc_stackCache[_local1] = _local2;
                } else {
                    _local2 = _local5;
                };
            };
            return (_local2);
        }
        public static function dateToShortTime(_arg1:Date):String{
            var _local2:Number = _arg1.AS3::getHours();
            var _local3:Number = _arg1.AS3::getMinutes();
            var _local4:Number = _arg1.AS3::getSeconds();
            var _local5:String = new String();
            if (_local2 < 10){
                _local5 = (_local5 + "0");
            };
            _local5 = (_local5 + _local2);
            _local5 = (_local5 + ":");
            if (_local3 < 10){
                _local5 = (_local5 + "0");
            };
            _local5 = (_local5 + _local3);
            _local5 = (_local5 + ":");
            if (_local4 < 10){
                _local5 = (_local5 + "0");
            };
            _local5 = (_local5 + _local4);
            return (_local5);
        }
        public static function addTraceLevel(_arg1:String, _arg2:int):void{
            if (null == Config.TRACE_SECTIONS){
                Config.TRACE_SECTIONS = {};
            };
            Config.TRACE_SECTIONS[_arg1] = _arg2;
        }
        public static function getAssetUrl(_arg1:String):String{
            var _local3:int;
            var _local2 = "";
            if (((Config.ASSET_PATHS) && ((Config.ASSET_PATHS.length > 0)))){
				_local2 = _arg1;
//                if (Engine.Zimfs.ZimfsLoader.assetExistsInDictionary(_arg1)){
//                    _local2 = _arg1;
//                } else {
//                    _local3 = (_arg1.length % Config.ASSET_PATHS.length);
//                    _local2 = (Config.ASSET_PATHS[0] + _arg1);
//                };
            } else {
                _local2 = _arg1;
            };
            return (_local2);
        }
        public static function setAssetUrls(_arg1:String, _arg2:String):void{
            var _local3:Array;
            var _local4:String;
            if (((_arg1) && ((_arg1.length > 1)))){
                Config.ASSET_PATHS.AS3::push(_arg1);
            };
            if (((_arg2) && ((_arg2.length > 1)))){
                _local3 = _arg2.AS3::split(",");
                if (((_local3) && ((_local3.length > 0)))){
                    for each (_local4 in _local3) {
                        Config.ASSET_PATHS.AS3::push(_local4);
                    };
                };
            };
        }
        public static function onGrantXP(_arg1:int):void{
            var delta:int = _arg1;
            try {
                if (((flash.external.ExternalInterface.available) && ((delta > 0)))){
                    flash.external.ExternalInterface.call("onGrantXP", delta);
                };
            } catch(e:Error) {
                GlobalEngine.log("zPoints", "grantXP callback failed");
            };
        }
        public static function assert(_arg1:Boolean, _arg2:String):void{
            if (!_arg1){
                error("Assert", ("ASSERTION FAILED - " + _arg2));
                flash.debugger.enterDebugger();
            };
        }

    }
}//package 
