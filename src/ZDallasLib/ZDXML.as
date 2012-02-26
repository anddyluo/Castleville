//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib{
    public dynamic class ZDXML {

        public function convert(_arg1:XML):void{
            this.convertToObject(_arg1, null);
        }
        public function getData(){
            if (this._zdxmlData){
                return (this._zdxmlData);
            };
            return (String(""));
        }
        public function firstMatchOnAttributeString(_arg1:String, _arg2:String):ZDXML{
            var _local3:String;
            for (_local3 in this) {
                if ((this[_local3] is ZDXML)){
                    if (this[_local3][_arg1] == _arg2){
                        return (this[_local3]);
                    };
                };
            };
            return (null);
        }
        public function allMatchesOnAttributeString(_arg1:String, _arg2:String):ZDXML{
            var _local4:String;
            var _local3:ZDXML = new ZDXML();
            for (_local4 in this) {
                if ((this[_local4] is ZDXML)){
                    if (this[_local4][_arg1] == _arg2){
                        _local3[_local4] = this[_local4];
                    };
                };
            };
            return (_local3);
        }
        public function countArrayObjects():uint{
            var _local2:String;
            var _local3:Object;
            if (!this._zdxmlIsArray){
                return (0);
            };
            var _local1:uint;
            for (_local2 in this) {
                _local3 = this[_local2];
                if ((_local3 is ZDXML)){
                    _local1++;
                };
            };
            return (_local1);
        }
        public function arrayConvert():void{
            var _local1:String;
            var _local2:ZDXML;
            var _local3:Array;
            var _local4:String;
            var _local5:int;
            if (!this._zdxmlIsArray){
                _local1 = (this._zdxmlLabel + "__idx0");
                _local2 = new ZDXML();
                _local3 = [];
                for (_local4 in this) {
                    _local2[_local4] = this[_local4];
                    _local3.AS3::push(_local4);
                };
                _local5 = 0;
                while (_local5 < _local3.length) {
                    delete this[_local3[_local5]];
                    _local5++;
                };
                this._zdxmlIsArray = true;
                this._zdxmlArrayLength = 1;
                this[_local1] = _local2;
            };
        }
        public function objOnly():ZDXML{
            var _local2:String;
            var _local3:Object;
            var _local1:ZDXML = new ZDXML();
            for (_local2 in this) {
                _local3 = this[_local2];
                if ((_local3 is ZDXML)){
                    _local1[_local2] = _local3;
                };
            };
            return (_local1);
        }
        public function expandChildren():ZDXML{
            var _local2:String;
            var _local3:Object;
            var _local4:String;
            var _local5:Object;
            var _local1:ZDXML = new ZDXML();
            for (_local2 in this) {
                _local3 = this[_local2];
                if ((_local3 is ZDXML)){
                    if (_local3._zdxmlIsArray){
                        for (_local4 in _local3) {
                            _local5 = _local3[_local4];
                            if ((_local5 is ZDXML)){
                                _local1[_local4] = _local5;
                            };
                        };
                    } else {
                        _local1[_local2] = _local3;
                    };
                };
            };
            return (_local1);
        }
        private function convertToObject(_arg1:XML, _arg2:ZDXML):void{
            var _local7:Number;
            var _local8:String;
            var _local10:int;
            var _local11:String;
            var _local12:String;
            var _local13:ZDXML;
            var _local14:XMLList;
            var _local15:int;
            var _local16:int;
            var _local3:XMLList = _arg1.attributes();
            var _local4:ZDXML;
            if (_arg2 == null){
                _local4 = this;
            } else {
                _local4 = new ZDXML();
            };
            var _local5:Array = [];
            var _local6:Boolean;
            if (_arg1.name() != null){
                _local4._zdxmlLabel = _arg1.name().toString();
            };
            var _local9:int = ((_local3) ? _local3.length() : 0);
            if (((!((_local3 == null))) && ((_local9 > 0)))){
                _local10 = 0;
                while (_local10 < _local9) {
                    _local8 = _local3[_local10].name();
                    _local5[0] = _local8;
                    _local5[1] = _local3[_local10].toString();
                    _local7 = Number(_local5[1]);
                    if (((!(isNaN(_local7))) && (!((_local5[1] == ""))))){
                        _local5[1] = _local7;
                    } else {
                        if (_local5[1] == "true"){
                            _local5[1] = new Boolean(true);
                        } else {
                            if (_local5[1] == "false"){
                                _local5[1] = new Boolean(false);
                            };
                        };
                    };
                    _local4[_local5[0]] = _local5[1];
                    _local10++;
                };
            } else {
                if (_arg1.hasComplexContent() == false){
                    if (_arg1.children().length() == 0){
                        if (_local4._zdxmlLabel){
                            _arg2[_local4._zdxmlLabel] = "";
                        } else {
                            _arg2._zdxmlData = _arg1.valueOf().toString();
                        };
                        return;
                    };
                    _local11 = _arg1.children()[0].toString();
                    _local8 = _arg1.name().toString();
                    _local7 = Number(_local11);
                    if (((!(isNaN(_local7))) && (!((_local11 == ""))))){
                        _arg2[_local8] = _local7;
                    } else {
                        if (_local11 == "true"){
                            _arg2[_local8] = new Boolean(true);
                        } else {
                            if (_local11 == "false"){
                                _arg2[_local8] = new Boolean(false);
                            } else {
                                _arg2[_local8] = _local11;
                            };
                        };
                    };
                    _local6 = true;
                };
            };
            if (((!((_arg2 == null))) && (!(_local6)))){
                _local8 = _arg1.name().toString();
                if (((!((_arg2[_local8] == null))) && ((_arg2[_local8] is ZDXML)))){
                    if (_arg2[_local8]._zdxmlIsArray){
                        _local12 = ((_local8 + "__idx") + _arg2[_local8]._zdxmlArrayLength.toString());
                        _arg2[_local8][_local12] = _local4;
                        _arg2[_local8]._zdxmlArrayLength++;
                    } else {
                        _local13 = _arg2[_local8];
                        _arg2[_local8] = new ZDXML();
                        _arg2[_local8]._zdxmlIsArray = Boolean(true);
                        _arg2[_local8]._zdxmlArrayLength = 2;
                        _local12 = (_local8 + "__idx0");
                        _arg2[_local8][_local12] = _local13;
                        _local12 = (_local8 + "__idx1");
                        _arg2[_local8][_local12] = _local4;
                    };
                } else {
                    _arg2[_local8] = _local4;
                };
            };
            if (!_local6){
                _local14 = _arg1.children();
                _local15 = _local14.length();
                _local16 = 0;
                while (_local16 < _local15) {
                    this.convertToObject(_local14[_local16], _local4);
                    _local16++;
                };
            };
        }

    }
}//package ZDallasLib
