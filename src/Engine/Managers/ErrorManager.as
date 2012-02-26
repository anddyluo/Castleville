//Created by Action Script Viewer - http://www.buraks.com/asv
package Engine.Managers{
    import flash.events.EventDispatcher;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.system.Capabilities;
    import flash.events.ErrorEvent;

    public class ErrorManager extends flash.events.EventDispatcher {

        private static const REPORT_DELAY:int = 10000;
        public static const ERROR_UNKNOWN:int = 0;
        public static const ERROR_FAILED_TO_LOAD:int = 1;
        public static const ERROR_LOAD_TIMED_OUT:int = 2;
        public static const ERROR_LOAD_SECURITY_ERROR:int = 3;
        public static const ERROR_LOAD_HTTP_ERROR:int = 4;
        public static const ERROR_LOAD_IO_ERROR:int = 5;
        public static const ERROR_REMOTEOBJECT_FAULT:int = 6;

        protected static var m_errors:Array = new Array();
        protected static var m_timer:flash.utils.Timer = new flash.utils.Timer(REPORT_DELAY);
        protected static var m_instance:ErrorManager;

        public function ErrorManager(){
            m_timer.addEventListener(flash.events.TimerEvent.TIMER, onReport, false, 0, true);
            m_timer.start();
        }
        public static function getInstance():ErrorManager{
            if (m_instance == null){
                m_instance = new (ErrorManager)();
            };
            return (m_instance);
        }
        public static function addError(_arg1:String, _arg2:int=0, _arg3:Object=null):void{
            m_errors.AS3::push({
                message:_arg1,
                type:_arg2,
                version:flash.system.Capabilities.version,
                fields:_arg3
            });
            GlobalEngine.log("ErrorManager", (((_arg1 + " (Type: ") + _arg2) + ")"));
            getInstance().dispatchEvent(new flash.events.ErrorEvent(flash.events.ErrorEvent.ERROR, false, false, _arg1));
        }
        private static function onReport(_arg1:flash.events.TimerEvent):void{
            if (m_errors.length){
                m_errors = [];
            };
        }

    }
}//package Engine.Managers
