//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Avatar2{
    import flash.events.Event;

    public class AnimationTriggerEvent extends flash.events.Event {

        public static const TRIGGER_FIRED:String = "TRIGGER_FIRED";

        private var m_triggerData:AnimationTriggerData;
        private var m_sender:Object;

        public function AnimationTriggerEvent(_arg1:String, _arg2:AnimationTriggerData, _arg3:Object){
            super(_arg1, false, false);
            this.m_triggerData = _arg2;
            this.m_sender = _arg3;
        }
        public function get triggerData():AnimationTriggerData{
            return (this.m_triggerData);
        }
        public function get sender():Object{
            return (this.m_sender);
        }

    }
}//package ZDallasLib.Avatar2
