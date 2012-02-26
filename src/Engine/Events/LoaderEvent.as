//Created by Action Script Viewer - http://www.buraks.com/asv
package Engine.Events{
    import flash.events.Event;

    public class LoaderEvent extends flash.events.Event {

        public static const LOAD_QUEUE_EMPTY:String = "loadqueueempty";
        public static const LOADED:String = "loaded";
        public static const ALL_HIGH_PRIORITY_LOADED:String = "high_priority_loaded";

        private var m_eventData:Object = null;

        public function LoaderEvent(_arg1:String):void{
            super(_arg1);
        }
        public function get eventData():Object{
            return (this.m_eventData);
        }
        public function set eventData(_arg1:Object):void{
            this.m_eventData = _arg1;
        }

    }
}//package Engine.Events
