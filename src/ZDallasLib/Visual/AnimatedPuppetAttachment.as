//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Visual{
    import flash.events.EventDispatcher;
    import ZDallasLib.Avatar2.SkinIntermediary;
    import ZDallasLib.Avatar2.Skeleton;
    import ZDallasLib.Avatar2.SkinContainerRef;
    import ZDallasLib.Avatar2.SkinManager;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import ZDallasLib.Avatar2.SkinContainer;

    public class AnimatedPuppetAttachment extends flash.events.EventDispatcher {

        private var m_skinURL:String;
        private var m_skin:ZDallasLib.Avatar2.SkinIntermediary;
        private var m_skinContainerRefs:Array;
        private var m_skinContainerNames:Array;
        private var m_useSkeletonScale:Boolean = true;
        private var m_colors:Array;
        private var m_skeleton:ZDallasLib.Avatar2.Skeleton;
        private var m_category:Array;
        private var m_conflictingCategories:Array;
        private var m_friendlyName:String;
        private var m_iconURL:String;
        public var forceZsciSpriteSheet:Boolean = true;

        public function AnimatedPuppetAttachment(_arg1:String, _arg2:Array){
            this.m_colors = [0x808080, 0x808080, 0x808080];
            this.m_category = [];
            this.m_conflictingCategories = [];
            super();
            this.m_skinURL = _arg1;
            this.m_skinContainerNames = _arg2;
        }
        public function get useSkeletonScale():Boolean{
            return (this.m_useSkeletonScale);
        }
        public function set useSkeletonScale(_arg1:Boolean):void{
            this.m_useSkeletonScale = _arg1;
        }
        public function setColor(_arg1:uint, _arg2:uint):void{
            var _local3:ZDallasLib.Avatar2.SkinContainerRef;
            if (_arg1 < this.m_colors.length){
                this.m_colors[_arg1] = _arg2;
                if (this.m_skinContainerRefs){
                    for each (_local3 in this.m_skinContainerRefs) {
                        _local3.setColor(_arg1, _arg2);
                    };
                };
            };
        }
        public function getColor(_arg1:uint):uint{
            return (this.m_colors[_arg1]);
        }
        public function get isAttachedToSkeleton():Boolean{
            return (!((this.m_skeleton == null)));
        }
        public function removeFromCategory(_arg1:String):void{
            var _local2:int = this.m_category.AS3::indexOf(_arg1);
            if (_local2 != -1){
                this.m_category.AS3::splice(_local2, 1);
            };
        }
        public function addToCategory(_arg1:String):void{
            if (((_arg1) && ((this.m_category.AS3::indexOf(_arg1) == -1)))){
                this.m_category.AS3::push(_arg1);
            };
        }
        public function get numCategories():uint{
            return (this.m_category.length);
        }
        public function getCategoryAt(_arg1:uint):String{
            return (this.m_category[_arg1]);
        }
        public function addConflictingCategory(_arg1:String):void{
            if (((_arg1) && ((this.m_conflictingCategories.AS3::indexOf(_arg1) == -1)))){
                this.m_conflictingCategories.AS3::push(_arg1);
            };
        }
        public function removeConflictingCategory(_arg1:String):void{
            var _local2:int = this.m_conflictingCategories.AS3::indexOf(_arg1);
            if (_local2 != -1){
                this.m_conflictingCategories.AS3::splice(_local2, 1);
            };
        }
        public function get numConflictingCategories():uint{
            return (this.m_conflictingCategories.length);
        }
        public function getConflictingCategoryAt(_arg1:uint):String{
            return (this.m_conflictingCategories[_arg1]);
        }
        public function isConflictingAttachment(_arg1:AnimatedPuppetAttachment):Boolean{
            var _local2:String;
            for each (_local2 in this.m_conflictingCategories) {
                if (_arg1.isInCategory(_local2)){
                    return (true);
                };
            };
            for each (_local2 in _arg1.m_conflictingCategories) {
                if (this.isInCategory(_local2)){
                    return (true);
                };
            };
            return (false);
        }
        public function get iconURL():String{
            return (this.m_iconURL);
        }
        public function set iconURL(_arg1:String):void{
            this.m_iconURL = _arg1;
        }
        public function isInCategory(_arg1:String):Boolean{
            return (!((this.m_category.AS3::indexOf(_arg1) == -1)));
        }
        public function get isLoaded():Boolean{
            return (((this.m_skin) && (this.m_skin.loaded)));
        }
        public function get isLoading():Boolean{
            return (((this.m_skin) && (this.m_skin.loading)));
        }
        public function get loadFailed():Boolean{
            return (((this.m_skin) && (this.m_skin.loadFailed)));
        }
        public function loadAssets(_arg1:uint=15):void{
            if (this.m_skin == null){
                this.m_skin = ZDallasLib.Avatar2.SkinManager.loadSkinFromURL(this.m_skinURL, _arg1, this.forceZsciSpriteSheet);
                if (((this.m_skin.loaded) || (this.m_skin.loadFailed))){
                    this.onSkinLoaded();
                } else {
                    this.m_skin.addEventListener(flash.events.Event.COMPLETE, this.onSkinLoaded);
                    this.m_skin.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onSkinLoaded);
                };
            };
        }
        public function attachToSkeleton(_arg1:ZDallasLib.Avatar2.Skeleton):void{
            var _local2:ZDallasLib.Avatar2.SkinContainer;
            var _local3:ZDallasLib.Avatar2.SkinContainerRef;
            this.detachFromSkeleton();
            this.m_skeleton = _arg1;
            if (((this.m_skeleton) && (this.isLoaded))){
                this.m_skinContainerRefs = [];
                for each (_local2 in this.m_skin.skinContainers) {
                    if ((((this.m_skinContainerNames == null)) || (!((this.m_skinContainerNames.AS3::indexOf(_local2.m_name) == -1))))){
                        _local3 = this.m_skeleton.addSkinContainer(_local2, _local2.m_jointName, this.m_useSkeletonScale);
                        if (_local3){
                            _local3.setColor(0, this.m_colors[0]);
                            _local3.setColor(1, this.m_colors[1]);
                            _local3.setColor(2, this.m_colors[2]);
                            this.m_skinContainerRefs.AS3::push(_local3);
                        };
                    };
                };
            };
        }
        public function detachFromSkeleton():void{
            if (((this.m_skeleton) && (this.m_skinContainerRefs))){
                while (this.m_skinContainerRefs.length > 0) {
                    this.m_skeleton.removeSkinContainer(this.m_skinContainerRefs.AS3::pop().skinContainer);
                };
                this.m_skinContainerRefs = null;
                this.m_skeleton = null;
            };
        }
        public function clone():AnimatedPuppetAttachment{
            var _local1:AnimatedPuppetAttachment = new AnimatedPuppetAttachment(this.m_skinURL, this.m_skinContainerNames);
            _local1.m_useSkeletonScale = this.m_useSkeletonScale;
            _local1.m_colors[0] = this.m_colors[0];
            _local1.m_colors[1] = this.m_colors[1];
            _local1.m_colors[2] = this.m_colors[2];
            _local1.m_category = this.m_category;
            _local1.m_friendlyName = this.m_friendlyName;
            _local1.m_iconURL = this.m_iconURL;
            if (((this.isLoaded) || (this.isLoading))){
                _local1.loadAssets();
            };
            return (_local1);
        }
        private function onSkinLoaded(_arg1:flash.events.Event=null):void{
            this.m_skin.removeEventListener(flash.events.Event.COMPLETE, this.onSkinLoaded);
            this.m_skin.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onSkinLoaded);
            if (this.m_skin.loadFailed){
                dispatchEvent(new flash.events.IOErrorEvent(flash.events.IOErrorEvent.IO_ERROR));
            } else {
                dispatchEvent(new flash.events.Event(flash.events.Event.COMPLETE));
            };
        }

    }
}//package ZDallasLib.Visual
