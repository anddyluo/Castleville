//Created by Action Script Viewer - http://www.buraks.com/asv
package {
    public class Config {

        public static var SN_APP_URL:String = "";
        public static var BASE_PATH:String = "127.0.0.1";
        public static var SERVICES_GATEWAY_PATH:String = (BASE_PATH + "flashservices/gateway.php");
        public static var ASSET_BASE_PATH:String = "";
        public static var RECORD_STATS_PATH:String = (BASE_PATH + "record_stats.php");
        public static var ASSET_POLICY_FILE:String = "";
        public static var ASSET_PATHS:Array = new Array();
        public static var DEBUG_MODE:Boolean = false;
        public static var IS_ADMIN:Boolean = false;
        public static var FILE_STATUS_RECORDING_ENABLED:Boolean = true;
        public static var VERBOSE_ERROR_DISPLAY:Boolean = false;
        public static var LOAD_CONFIG_LOCALLY:Boolean = false;
        public static var LOAD_ASSETS_LOCALLY:Boolean = false;
        public static var TRANSACTION_INACTIVITY_SECONDS:Number = ((5 * 60) * 1000);//300000
        public static var LOG_ASSET_REQUESTS:Boolean = false;
        public static var verboseLogging:Boolean = true;
        public static var VIEWPORT_CLEAR_COLOR:uint = 0xFF009ACD;
        public static var TRACE_SECTIONS:Object = null;
//        public static var TRACE_DEFAULT_LEVEL:int = GlobalEngine.LEVEL_INFO;//3
//        public static var INVERT_TRACE:Boolean = false;

    }
}//package 
