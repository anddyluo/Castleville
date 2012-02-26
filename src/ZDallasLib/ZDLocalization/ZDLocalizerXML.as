//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.ZDLocalization{
    import ZLocalization.Localizer;
    import ZDallasLib.ZDXML;
    import ZLocalization.LocalizedString;

    public class ZDLocalizerXML extends ZLocalization.Localizer {

        public function ZDLocalizerXML(_arg1:XML){
            var _local3:ZDallasLib.ZDXML;
            var _local4:Object;
            var _local5:String;
            var _local6:ZDallasLib.ZDXML;
            super(_arg1);
            this.m_raw = {};
            this.m_cached = {};
            var _local2:ZDallasLib.ZDXML = new ZDallasLib.ZDXML();
            _local2.convert(_arg1);
            for each (_local3 in _local2.pkg.objOnly()) {
                _local4 = {};
                if (_local3.string){
                    _local3.string.arrayConvert();
                    for each (_local6 in _local3.string.objOnly()) {
                        _local4[_local6.key] = _local6;
                    };
                };
                _local5 = _local3.name;
                this.m_raw[_local5] = _local4;
                this.m_cached[_local5] = {};
            };
            this.m_locale = _local2.locale;
            this.setSubstituter();
        }
        protected function parseStringNode(_arg1:ZDallasLib.ZDXML):ZLocalization.LocalizedString{
            var _local5:ZDallasLib.ZDXML;
            var _local2:String = _arg1.original;
            var _local3:Object = {};
            if (_arg1.variation){
                _arg1.variation.arrayConvert();
                for each (_local5 in _arg1.variation.objOnly()) {
                    _local3[_local5.index] = _local5.getData();
                };
            };
            var _local4:ZLocalization.LocalizedString = new ZLocalization.LocalizedString(_local2, _local3);
            if (_arg1.gender){
                _local4.gender = _arg1.gender;
            };
            return (_local4);
        }
        override public function getString(_arg1:String, _arg2:String):ZLocalization.LocalizedString{
            if (!this.m_raw.AS3::hasOwnProperty(_arg1)){
                return (null);
            };
            if (!this.m_cached[_arg1].hasOwnProperty(_arg2)){
                if (this.m_raw[_arg1].hasOwnProperty(_arg2)){
                    this.m_cached[_arg1][_arg2] = this.parseStringNode(this.m_raw[_arg1][_arg2]);
                } else {
                    return (null);
                };
            };
            return (this.m_cached[_arg1][_arg2]);
        }

    }
}//package ZDallasLib.ZDLocalization
