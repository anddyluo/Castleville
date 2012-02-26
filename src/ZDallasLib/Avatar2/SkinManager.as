//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Avatar2{
    import flash.utils.Dictionary;

    public class SkinManager {

        private static var m_skins:flash.utils.Dictionary = new flash.utils.Dictionary();

        public static function loadSkinFromURL(_arg1:String, _arg2:uint=15, _arg3:Boolean=true):SkinIntermediary{
            var _local4:SkinIntermediary = m_skins[_arg1];
            if (_local4 == null){
                _local4 = new SkinIntermediary();
                _local4.forceSpriteSheetToZsci = _arg3;
                _local4.assetBase = _arg1.AS3::replace(/\/[^\/]*$/, "/");
                _local4.load(_arg1, _arg2);
                m_skins[_arg1] = _local4;
            };
            return (_local4);
        }

    }
}//package ZDallasLib.Avatar2
