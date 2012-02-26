//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Avatar2{
    public class AnimationTriggerData {

        public var time:Number;
        public var type:String;
        public var data:String;

        public function AnimationTriggerData(_arg1:String, _arg2:String, _arg3:Number){
            this.time = _arg3;
            this.type = _arg1;
            this.data = _arg2;
        }
        public function clone():AnimationTriggerData{
            return (new AnimationTriggerData(this.type, this.data, this.time));
        }

    }
}//package ZDallasLib.Avatar2
