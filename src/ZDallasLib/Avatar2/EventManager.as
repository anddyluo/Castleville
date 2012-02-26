//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Avatar2{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    public class EventManager extends flash.events.EventDispatcher {

        protected static var _instance:EventManager;

        public function EventManager(_arg1:flash.events.IEventDispatcher=null){
            super(_arg1);
        }
        public static function getInstance():EventManager{
            if (!_instance){
                _instance = new (EventManager)();
            };
            return (_instance);
        }

    }
}//package ZDallasLib.Avatar2
