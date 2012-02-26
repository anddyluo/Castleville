//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Avatar2{
    import flash.utils.Dictionary;
    import flash.utils.ByteArray;

    public class AnimationLibrary {

        private var m_id:String;
        private var m_animClips:flash.utils.Dictionary;

        public function AnimationLibrary(_arg1:String){
            this.m_animClips = new flash.utils.Dictionary();
            super();
            this.m_id = new String(_arg1);
        }
        public function getAnimationClip(_arg1:String):GameAnimationClip{
            var _local4:GameAnimationClip;
            var _local2:String = _arg1.AS3::toLowerCase();
            var _local3:Object = this.m_animClips[_local2];
            if ((_local3 is flash.utils.ByteArray)){
                _local4 = new GameAnimationClip();
                _local4.initJointData((_local3 as flash.utils.ByteArray));
                _local4.name = _arg1;
                this.m_animClips[_local2] = _local4;
                return (_local4);
            };
            return ((_local3 as GameAnimationClip));
        }
        public function addClipFromBytes(_arg1:String, _arg2:flash.utils.ByteArray):void{
            this.m_animClips[_arg1.AS3::toLowerCase()] = _arg2;
        }
        public function addClip(_arg1:String, _arg2:GameAnimationClip):void{
            var _local3:GameAnimationClip = (this.m_animClips[_arg1.AS3::toLowerCase()] as GameAnimationClip);
            if (_local3){
                throw (new Error((("clip " + _arg1) + " is already present in AnimationLibrary")));
            };
            this.m_animClips[_arg1.AS3::toLowerCase()] = _arg2;
        }

    }
}//package ZDallasLib.Avatar2
