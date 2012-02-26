//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Visual{
    import flash.utils.Dictionary;

    public class AnimatedPuppetManager {

        private static var m_configs:Object = {};
        private static var m_colorSets:Object = {};

        public static function initialize(_arg1:XML):void{
            var _local2:XML;
            var _local3:XML;
            var _local4:Array;
            var _local5:XML;
            var _local6:Object;
            for each (_local2 in _arg1.avatar) {
                addPuppetConfig(_local2.@name, _local2);
            };
            for each (_local3 in _arg1.colorSets.colorSet) {
                _local4 = [];
                for each (_local5 in _local3.color) {
                    _local6 = {
                        name:((("@name" in _local5)) ? _local5.@name.toString() : _local5.@key.toString()),
                        key:uint(_local5.@key),
                        color:uint(_local5.@color)
                    };
                    _local4.AS3::push(_local6);
                };
                m_colorSets[_local3.@name.toString()] = _local4;
            };
        }
        public static function addPuppetConfig(_arg1:String, _arg2:XML):void{
            var _local4:XML;
            var _local5:XML;
            var _local6:Object;
            var _local7:String;
            var _local8:XML;
            var _local9:XML;
            var _local10:Array;
            var _local11:XML;
            var _local12:XML;
            var _local13:Array;
            var _local14:String;
            var _local15:Array;
            var _local16:String;
            var _local17:String;
            var _local18:String;
            var _local19:Array;
            var _local20:String;
            var _local21:Object;
            var _local22:XML;
            var _local3:Object = {};
            _local3.baseSkinURL = _arg2.@baseSkinURL.toString();
            _local3.largeSkinURL = ((("@largeSkinURL" in _arg2)) ? _arg2.@largeSkinURL.toString() : _local3.baseSkinURL.replace(".asc", "_large.asc"));
            _local3.baseArchetypeURL = _arg2.@baseArchetypeURL.toString();
            _local3.defaultAnimation = ((("@defaultAnimation" in _arg2)) ? _arg2.@defaultAnimation.toString() : "idle");
            _local3.defaultAttachments = [];
            _local3.useSkeletonScale = !((_arg2.@useSkeletonScale.toString() == "false"));
            _local3.partLists = new flash.utils.Dictionary();
            _local3.attachments = new flash.utils.Dictionary();
            _local3.sex = ((((("@sex" in _arg2)) && ((_arg2.@sex.toString().toLowerCase() == "female")))) ? "female" : "male");
            _local3.defaultColors = {};
            _local3.forceZsciSpriteSheet = ((("@forceZsciSpriteSheet" in _arg2)) ? !((_arg2.@forceZsciSpriteSheet.toString() == "false")) : true);
            for each (_local4 in _arg2.defaultAttachments.defaultAttachment) {
                _local3.defaultAttachments.push({
                    name:_local4.@name.toString(),
                    category:_local4.@category.toString()
                });
            };
            for each (_local5 in _arg2.attachmentPartList) {
                _local10 = [];
                for each (_local11 in _local5.part) {
                    _local10.AS3::push(_local11.@skinContainer.toString());
                };
                if (_local10.length > 0){
                    _local3.partLists[_local5.@name.toString()] = _local10;
                };
            };
            for each (_local8 in _arg2.attachment) {
                _local7 = _local8.@name.toString();
                _local6 = {};
                _local6.skinURL = _local8.@skinURL.toString();
                _local6.largeSkinURL = ((("@largeSkinURL" in _local8)) ? _local8.@largeSkinURL.toString() : _local6.skinURL.replace(".asc", "_large.asc"));
                _local6.partNames = [];
                _local6.iconURL = ((("@iconURL" in _local8)) ? _local8.@iconURL.toString() : null);
                _local6.conflicts = [];
                _local3.attachments[_local7] = _local6;
                _local6.defaultColors = {};
                for each (_local12 in _local8.defaultColors.attributes()) {
                    _local6.defaultColors[_local12.localName()] = _local12.toString();
                };
                _local13 = _local8.@partList.toString().split(" ");
                for each (_local14 in _local13) {
                    _local15 = _local14.AS3::split(":");
                    _local16 = _local15[0];
                    _local17 = "";
                    if (_local15.length > 1){
                        _local17 = ("_" + _local15[1]);
                    };
                    if ((_local16 in _local3.partLists)){
                        for each (_local18 in _local3.partLists[_local16]) {
                            _local6.partNames.push((_local18 + _local17));
                        };
                    };
                };
            };
            for each (_local9 in _arg2.conflict) {
                _local19 = _local9.@conflicts.toString().split(/ +/);
                _local7 = _local9.@attachment.toString();
                _local6 = _local3.attachments[_local7];
                if (_local6){
                    for each (_local20 in _local19) {
                        _local21 = _local3.attachments[_local20];
                        if (((_local21) && (!((_local21 == _local6))))){
                            if (_local21.conflicts.indexOf(_local7) == -1){
                                _local21.conflicts.push(_local7);
                            };
                            if (_local6.conflicts.indexOf(_local20) == -1){
                                _local6.conflicts.push(_local20);
                            };
                        };
                    };
                };
            };
            if (("defaultColors" in _arg2)){
                for each (_local22 in _arg2.defaultColors.attributes()) {
                    _local3.defaultColors[_local22.localName()] = _local22.toString();
                };
            };
            m_configs[_arg1] = _local3;
        }
        public static function getPuppetConfig(_arg1:String):Object{
            return (m_configs[_arg1]);
        }
        public static function getColorSet(_arg1:String):Array{
            return (m_colorSets[_arg1]);
        }
        public static function getColor(_arg1:String, _arg2:String):Object{
            var _local3:Array;
            var _local4:Object;
            if (((_arg1) && (_arg2))){
                _local3 = getColorSet(_arg1);
                if (_local3){
                    for each (_local4 in _local3) {
                        if (_local4.name == _arg2){
                            return (_local4);
                        };
                    };
                };
            };
            return (null);
        }
        public static function getAttachmentColor(_arg1:String, _arg2:String, _arg3:String, _arg4:String):Object{
            var _local6:Object;
            var _local7:Object;
            var _local5:Object = getColor(_arg3, _arg4);
            if (_local5 == null){
                _local6 = m_configs[_arg1];
                if (_local6){
                    _local7 = _local6.attachments[_arg2];
                    if (_local7){
                        _local5 = getColor(_arg3, _local7.defaultColors[_arg3]);
                    };
                    if (_local5 == null){
                        _local5 = getColor(_arg3, _local6.defaultColors[_arg3]);
                    };
                };
            };
            return (_local5);
        }
        public static function createPuppet(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=true, _arg4:uint=15):AnimatedPuppet{
            var _local5:AnimatedPuppet;
            var _local7:String;
            var _local8:Object;
            var _local9:Object;
            var _local10:AnimatedPuppetAttachment;
            var _local6:Object = m_configs[_arg1];
            if (_local6){
                _local7 = ((_arg2) ? _local6.largeSkinURL : _local6.baseSkinURL);
                _local5 = new AnimatedPuppet();
                _local5.name = _arg1;
                _local5.loadFromXML(new XML((((((((('<visual archetype="' + _local6.baseArchetypeURL) + '" skin="') + _local7) + '" defaultAnimation="') + _local6.defaultAnimation) + '" forceZsciSpriteSheet="') + _local6.forceZsciSpriteSheet) + '"/>')));
                for each (_local8 in _local6.defaultAttachments) {
                    _local9 = {
                        useLargeSkin:_arg2,
                        colors:[{
                            colorSet:"primary",
                            color:null
                        }, {
                            colorSet:"secondary",
                            color:null
                        }]
                    };
                    _local10 = createPuppetAttachment(_arg1, _local8.name, _local9, _arg3, _arg4);
                    if (_local10){
                        _local10.addToCategory(_local8.category);
                        _local10.addToCategory(_local8.name);
                        _local5.addAttachment(_local10);
                    };
                };
                if (_arg3){
                    _local5.loadAssets(_arg4);
                };
            };
            return (_local5);
        }
        public static function createDefaultPuppetAttachment(_arg1:String, _arg2:String, _arg3:Boolean=false, _arg4:Boolean=true, _arg5:int=0):AnimatedPuppetAttachment{
            var _local8:Object;
            var _local9:Object;
            var _local6:AnimatedPuppetAttachment;
            var _local7:Object = m_configs[_arg1];
            if (_local7){
                for each (_local8 in _local7.defaultAttachments) {
                    if (_local8.category == _arg2){
                        _local9 = {
                            useLargeSkin:_arg3,
                            colors:[{
                                colorSet:"primary",
                                color:null
                            }, {
                                colorSet:"secondary",
                                color:null
                            }]
                        };
                        _local6 = createPuppetAttachment(_arg1, _local8.name, _local9, _arg4, _arg5);
                        if (_local6){
                            _local6.addToCategory(_arg2);
                        };
                        break;
                    };
                };
            };
            return (_local6);
        }
        public static function createPuppetAttachment(_arg1:String, _arg2:String, _arg3:Object=null, _arg4:Boolean=true, _arg5:uint=15):AnimatedPuppetAttachment{
            var _local6:AnimatedPuppetAttachment;
            var _local8:Object;
            var _local9:String;
            var _local10:String;
            var _local11:uint;
            var _local12:Object;
            var _local7:Object = m_configs[_arg1];
            if (_local7){
                _local8 = _local7.attachments[_arg2];
                if (_local8){
                    _local9 = ((_arg3.useLargeSkin) ? _local8.largeSkinURL : _local8.skinURL);
                    _local6 = new AnimatedPuppetAttachment(_local9, _local8.partNames);
                    _local6.addToCategory(_arg2);
                    for each (_local10 in _local8.conflicts) {
                        _local6.addConflictingCategory(_local10);
                    };
                    _local6.iconURL = _local8.iconURL;
                    if (_arg4){
                        _local6.loadAssets(_arg5);
                    };
                    if (_arg3){
                        if (("colors" in _arg3)){
                            _local11 = 0;
                            while (_local11 < _arg3.colors.length) {
                                if ((_arg3.colors[_local11] is Object)){
                                    _local12 = getAttachmentColor(_arg1, _arg2, _arg3.colors[_local11].colorSet, _arg3.colors[_local11].color);
                                    if (_local12){
                                        _local6.setColor(_local11, _local12.color);
                                    };
                                } else {
                                    if (_arg3.colors[_local11] != null){
                                        _local6.setColor(_local11, _arg3.colors[_local11]);
                                    };
                                };
                                _local11++;
                            };
                        };
                    };
                };
            };
            return (_local6);
        }

    }
}//package ZDallasLib.Visual
