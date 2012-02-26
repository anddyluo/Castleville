//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Visual{
    import flash.events.EventDispatcher;
    import ZDallasLib.Avatar2.SkinIntermediary;
    import ZDallasLib.Avatar2.Skeleton;
    import ZDallasLib.Avatar2.Archetype;
    import flash.display.Sprite;
    import ZDallasLib.Avatar2.GameAnimationClipInstance;
    import flash.utils.Dictionary;
    import flash.display.Bitmap;
    import flash.display.PixelSnapping;
    import flash.display.BitmapData;
    import ZDallasLib.Avatar2.SkinContainerRef;
    import __AS3__.vec.Vector;
    import flash.display.DisplayObject;
    import flash.geom.Rectangle;
    import flash.geom.Matrix;
    import flash.events.Event;
    import ZDallasLib.Avatar2.GameAnimationClip;
    import ZDallasLib.Avatar2.ArchetypeManager;
    import ZDallasLib.Avatar2.SkinManager;
    import ZDallasLib.Avatar2.AnimationTriggerEvent;
    import __AS3__.vec.*;

    public class AnimatedPuppet extends flash.events.EventDispatcher implements IVisualComponent {

        public static const ANIMATION_COMPLETE:String = "ANIMATION_COMPLETE";
        public static const ASSETS_LOADED:String = "ASSETS_LOADED";
        public static const UNMODIFIED_COLOR:uint = 0xFFFFFFFF;
        public static const FRAME_CACHE_CLEANUP_THRESHOLD:int = ((110 * 0x0400) * 0x0400);//115343360
        public static const FRAME_CACHE_CLEANUP_AMOUNT:int = ((90 * 0x0400) * 0x0400);//94371840

        private static var s_frameCacheHead:Object;
        private static var s_frameCacheTail:Object;
        public static var s_frameCacheNumBytes:int = 0;
        public static var s_frameCacheNumFrames:int = 0;
        public static var s_useSkeletonBitmaps:Boolean = true;
        public static var s_changeStageQuality:Boolean = true;
        public static var s_drawWithSmoothing:Boolean = false;

        private var m_skinURL:String;
        private var m_archetypeURL:String;
        private var m_skin:ZDallasLib.Avatar2.SkinIntermediary;
        private var m_skeleton:ZDallasLib.Avatar2.Skeleton;
        private var m_archetype:ZDallasLib.Avatar2.Archetype;
        private var m_sprite:flash.display.Sprite;
        private var m_animClipInstance:ZDallasLib.Avatar2.GameAnimationClipInstance;
        private var m_durationLimit:Number;
        private var m_durationLimitTimer:Number;
        private var m_defaultAnimation:String = "idle";
        private var m_dirty:Boolean = true;
        private var m_owner:Object;
        private var m_name:String;
        private var m_flipped:Boolean = false;
        private var m_attachments:Array;
        private var m_globalColors:Array;
        private var m_categoryColors:Object;
        private var m_cachedAnimClipInstances:flash.utils.Dictionary;
        private var m_hiddenAttachments:Array;
        private var m_disableTriggers:Boolean = false;
        private var m_loadingPriority:uint = 10;
        private var m_cachedFrames:Object;
        private var m_cacheFramesPerInstance:Boolean = false;
        private var m_currentCacheObject:Object;
        private var m_skeletonSprite:flash.display.Sprite;
        private var m_cachedBitmap:flash.display.Bitmap;
        private var m_template:AnimatedPuppet;
        private var m_cachedFramesEnabled:Boolean = true;
        private var m_forceZsciSpriteSheet:Boolean = true;
        private var m_destroyed:Boolean = false;
        private var m_debugFrames:flash.display.Sprite;

        public function AnimatedPuppet(){
            this.m_sprite = new flash.display.Sprite();
            this.m_attachments = [];
            this.m_globalColors = [UNMODIFIED_COLOR, UNMODIFIED_COLOR, UNMODIFIED_COLOR];
            this.m_categoryColors = {};
            this.m_cachedAnimClipInstances = new flash.utils.Dictionary();
            this.m_hiddenAttachments = [];
            this.m_cachedFrames = {};
            this.m_skeletonSprite = new flash.display.Sprite();
            this.m_cachedBitmap = new flash.display.Bitmap(null, flash.display.PixelSnapping.AUTO, false);
            super();
            this.enableAnimFrameCache();
        }
        private static function removeFrameCacheObject(_arg1:Object):void{
            var _local2:Boolean;
            if (_arg1){
                _local2 = false;
                if (_arg1.next){
                    _arg1.next.prev = _arg1.prev;
                    _local2 = true;
                };
                if (_arg1.prev){
                    _arg1.prev.next = _arg1.next;
                    _local2 = true;
                };
                if (s_frameCacheHead == _arg1){
                    s_frameCacheHead = _arg1.next;
                    _local2 = true;
                };
                if (s_frameCacheTail == _arg1){
                    s_frameCacheTail = _arg1.prev;
                    _local2 = true;
                };
                if (_local2){
                    _arg1.next = null;
                    _arg1.prev = null;
                    s_frameCacheNumFrames--;
                    if (_arg1.data){
                        s_frameCacheNumBytes = (s_frameCacheNumBytes - ((_arg1.data.width * _arg1.data.height) * 4));
                    };
                };
            };
        }
        private static function addFrameCacheObject(_arg1:Object):void{
            if (((((((_arg1) && ((_arg1.prev == null)))) && ((_arg1.next == null)))) && (!((s_frameCacheTail == _arg1))))){
                if (s_frameCacheTail != null){
                    _arg1.prev = s_frameCacheTail;
                    _arg1.prev.next = _arg1;
                    s_frameCacheTail = _arg1;
                } else {
                    s_frameCacheHead = _arg1;
                    s_frameCacheTail = _arg1;
                };
                s_frameCacheNumFrames++;
                if (_arg1.data){
                    s_frameCacheNumBytes = (s_frameCacheNumBytes + ((_arg1.data.width * _arg1.data.height) * 4));
                };
            };
        }
        private static function deleteFrameCacheObject(_arg1:Object):void{
            if (_arg1){
                removeFrameCacheObject(_arg1);
                if (_arg1.data){
                    _arg1.data.dispose();
                };
            };
        }
        public static function cleanupAnimFrameCache():void{
            var _local2:flash.display.BitmapData;
            var _local1:Object = s_frameCacheHead;
            while (((_local1) && ((s_frameCacheNumBytes > FRAME_CACHE_CLEANUP_AMOUNT)))) {
                if (((_local1.data) && ((_local1.bitmaps.length == 0)))){
                    _local2 = _local1.data;
                    s_frameCacheNumBytes = (s_frameCacheNumBytes - ((_local2.width * _local2.height) * 4));
                    _local1.data.dispose();
                    _local1.data = null;
                    _local1.dirty = true;
                };
                _local1 = _local1.next;
            };
        }

        public function get owner():Object{
            return (this.m_owner);
        }
        public function set owner(_arg1:Object):void{
            this.m_owner = _arg1;
        }
        public function get name():String{
            return (this.m_name);
        }
        public function set name(_arg1:String):void{
            this.m_name = _arg1;
        }
        public function get isAnimating():Boolean{
            return (((this.m_animClipInstance) && ((this.m_animClipInstance.fps > 0))));
        }
        public function get isDirty():Boolean{
            return (this.m_dirty);
        }
        public function disableTriggers():void{
            this.m_disableTriggers = true;
            if (this.m_animClipInstance){
                this.m_animClipInstance.disableTriggers();
            };
        }
        public function enableTriggers():void{
            this.m_disableTriggers = false;
            if (this.m_animClipInstance){
                this.m_animClipInstance.enableTriggers();
            };
        }
        public function get defaultAnimationName():String{
            return (this.m_defaultAnimation);
        }
        public function set defaultAnimationName(_arg1:String):void{
            var _local2:Boolean;
            if (_arg1 != this.m_defaultAnimation){
                _local2 = ((this.m_animClipInstance) && ((this.m_animClipInstance.name == this.m_defaultAnimation)));
                this.m_defaultAnimation = _arg1;
                if (_local2){
                    this.startDefaultAnimation();
                };
            };
        }
        public function get hasLoadedAllAttachments():Boolean{
            var _local1:AnimatedPuppetAttachment;
            for each (_local1 in this.m_attachments) {
                if (!_local1.isLoaded){
                    return (false);
                };
            };
            for each (_local1 in this.m_hiddenAttachments) {
                if (!_local1.isLoaded){
                    return (false);
                };
            };
            return (true);
        }
        public function get isLoadingAttachments():Boolean{
            var _local1:AnimatedPuppetAttachment;
            for each (_local1 in this.m_attachments) {
                if (_local1.isLoading){
                    return (true);
                };
            };
            for each (_local1 in this.m_hiddenAttachments) {
                if (_local1.isLoading){
                    return (true);
                };
            };
            return (false);
        }
        public function setGlobalColor(_arg1:uint, _arg2:uint):void{
            var _local3:AnimatedPuppetAttachment;
            var _local4:ZDallasLib.Avatar2.SkinContainerRef;
            this.m_globalColors[_arg1] = _arg2;
            for each (_local3 in this.m_attachments) {
                this.refreshAttachmentColors(_local3);
            };
            if (this.m_skeleton){
                for each (_local4 in this.m_skeleton.skinContainers) {
                    _local4.setColor(_arg1, _arg2);
                };
            };
        }
        public function setCategoryColor(_arg1:String, _arg2:uint, _arg3:uint):void{
            var _local4:AnimatedPuppetAttachment;
            this.m_categoryColors[_arg1] = ((this.m_categoryColors[_arg1]) || ([UNMODIFIED_COLOR, UNMODIFIED_COLOR, UNMODIFIED_COLOR]));
            this.m_categoryColors[_arg1][_arg2] = _arg3;
            for each (_local4 in this.m_attachments) {
                if (_local4.isInCategory(_arg1)){
                    this.refreshAttachmentColors(_local4);
                };
            };
        }
        public function getCategoryColor(_arg1:String, _arg2:uint):uint{
            return ((((_arg1 in this.m_categoryColors)) ? this.m_categoryColors[_arg1][_arg2] : UNMODIFIED_COLOR));
        }
        public function refreshAttachments():void{
            var _local1:AnimatedPuppetAttachment;
            for each (_local1 in this.m_attachments) {
                this.refreshAttachmentColors(_local1);
                _local1.attachToSkeleton(this.m_skeleton);
                this.m_dirty = true;
            };
        }
        private function refreshAttachmentColors(_arg1:AnimatedPuppetAttachment):void{
            var _local3:String;
            var _local4:Array;
            var _local5:uint;
            var _local2:uint;
            while (_local2 < this.m_globalColors.length) {
                if (((!((this.m_globalColors[_local2] == UNMODIFIED_COLOR))) && (!((this.m_globalColors[_local2] == _arg1.getColor(_local2)))))){
                    _arg1.setColor(_local2, this.m_globalColors[_local2]);
                    this.m_dirty = true;
                };
                _local2++;
            };
            for (_local3 in this.m_categoryColors) {
                if (_arg1.isInCategory(_local3)){
                    _local4 = this.m_categoryColors[_local3];
                    _local5 = 0;
                    while (_local5 < _local4.length) {
                        if (((!((_local4[_local5] == UNMODIFIED_COLOR))) && (!((_local4[_local5] == _arg1.getColor(_local5)))))){
                            _arg1.setColor(_local5, _local4[_local5]);
                            this.m_dirty = true;
                        };
                        _local5++;
                    };
                };
            };
        }
        public function addAttachment(_arg1:AnimatedPuppetAttachment):void{
            if (this.m_attachments.AS3::indexOf(_arg1) == -1){
                this.m_attachments.AS3::push(_arg1);
                this.refreshAttachmentColors(_arg1);
                if (this.isLoaded){
                    _arg1.attachToSkeleton(this.m_skeleton);
                };
            };
        }
        public function removeAttachment(_arg1:AnimatedPuppetAttachment):void{
            var _local2:int = this.m_attachments.AS3::indexOf(_arg1);
            if (_local2 != -1){
                this.m_attachments.AS3::splice(_local2, 1);
                _arg1.detachFromSkeleton();
            };
            _local2 = this.m_hiddenAttachments.AS3::indexOf(_arg1);
            if (_local2 != -1){
                this.m_hiddenAttachments.AS3::splice(_local2, 1);
            };
        }
        public function get numAttachments():uint{
            return (this.m_attachments.length);
        }
        public function getAttachmentAt(_arg1:uint):AnimatedPuppetAttachment{
            return (this.m_attachments[_arg1]);
        }
        public function isAttached(_arg1:AnimatedPuppetAttachment):Boolean{
            return (!((this.m_attachments.AS3::indexOf(_arg1) == -1)));
        }
        public function getAttachmentsByCategory(_arg1:String):Vector.<AnimatedPuppetAttachment>{
            var _local3:AnimatedPuppetAttachment;
            var _local2:Vector.<AnimatedPuppetAttachment> = new Vector.<AnimatedPuppetAttachment>();
            for each (_local3 in this.m_attachments) {
                if (_local3.isInCategory(_arg1)){
                    _local2.AS3::push(_local3);
                };
            };
            return (_local2);
        }
        public function removeAttachmentsInCategory(_arg1:String):void{
            var _local2:AnimatedPuppetAttachment;
            for each (_local2 in this.m_attachments) {
                if (_local2.isInCategory(_arg1)){
                    this.removeAttachment(_local2);
                };
            };
        }
        public function hideAttachmentsInCategory(_arg1:String):void{
            var _local3:AnimatedPuppetAttachment;
            var _local2:Array = [];
            for each (_local3 in this.m_attachments) {
                if (_local3.isInCategory(_arg1)){
                    _local2.AS3::push(_local3);
                };
            };
            for each (_local3 in _local2) {
                this.hideAttachment(_local3);
            };
        }
        public function showAttachmentsInCategory(_arg1:String):void{
            var _local3:AnimatedPuppetAttachment;
            var _local2:Array = [];
            for each (_local3 in this.m_hiddenAttachments) {
                if (_local3.isInCategory(_arg1)){
                    _local2.AS3::push(_local3);
                };
            };
            for each (_local3 in _local2) {
                this.m_hiddenAttachments.AS3::splice(this.m_hiddenAttachments.AS3::indexOf(_local3), 1);
                this.addAttachment(_local3);
            };
        }
        public function hideAttachment(_arg1:AnimatedPuppetAttachment):void{
            var _local2:uint = this.m_attachments.AS3::indexOf(_arg1);
            if (_local2 != -1){
                this.m_attachments.AS3::splice(this.m_attachments.AS3::indexOf(_arg1), 1);
                _arg1.detachFromSkeleton();
                this.m_hiddenAttachments.AS3::push(_arg1);
                this.m_dirty = true;
            };
        }
        public function get flipped():Boolean{
            return (this.m_flipped);
        }
        public function set flipped(_arg1:Boolean):void{
            if (_arg1 != this.m_flipped){
                this.m_flipped = _arg1;
                this.m_dirty = true;
            };
        }
        public function getDisplayObject():flash.display.DisplayObject{
            this.updateDisplayObject();
            return (this.m_sprite);
        }
        public function updateDisplayObject(_arg1:Boolean=false):void{
            var _local2:int;
            var _local3:Object;
            var _local4:flash.geom.Rectangle;
            var _local5:int;
            var _local6:int;
            var _local7:flash.display.BitmapData;
            var _local8:String;
            var _local9:flash.geom.Matrix;
            var _local10:flash.display.Bitmap;
            var _local11:int;
            if (((!(this.m_destroyed)) && (((this.m_dirty) || (_arg1))))){
                this.m_flipped = this.flipped;
                if (this.m_skeleton){
                    if (this.m_animClipInstance){
                        if (this.m_cachedFramesEnabled){
                            _local2 = (int((this.m_animClipInstance.position * this.m_animClipInstance.fps)) % (int((this.m_animClipInstance.duration * this.m_animClipInstance.fps)) + 1));
                            _local3 = this.m_cachedFrames[this.m_animClipInstance.name][_local2];
                            if (_local3 == null){
                                _local3 = {
                                    data:null,
                                    dirty:true,
                                    bitmaps:[]
                                };
                                this.m_cachedFrames[this.m_animClipInstance.name][_local2] = _local3;
                            } else {
                                AnimatedPuppet.removeFrameCacheObject(_local3);
                            };
                            if (_local3.dirty){
                                this.m_skeleton.updateJoints(false);
                                this.m_skeleton.renderSkinSprite(this.m_skeletonSprite, s_useSkeletonBitmaps);
                                _local4 = this.m_skeletonSprite.getRect(this.m_skeletonSprite);
                                if (this.m_skeletonSprite.width){
                                    _local5 = Math.ceil(this.m_skeletonSprite.width);
                                    _local6 = Math.ceil(this.m_skeletonSprite.height);
                                    _local7 = _local3.data;
                                    if ((((((_local7 == null)) || (!((_local7.width == _local5))))) || (!((_local7.height == _local6))))){
                                        if (_local7){
                                            _local7.dispose();
                                        };
                                        _local7 = new flash.display.BitmapData(Math.ceil(_local4.width), Math.ceil(_local4.height), true, 0);
                                        for each (_local10 in _local3.bitmaps) {
                                            _local10.bitmapData = _local7;
                                        };
                                    };
                                    _local8 = null;
                                    if (s_changeStageQuality){
                                        if (GlobalEngine.stage.quality != GlobalEngine.STAGE_QUALITY_HIGH){
                                            _local8 = GlobalEngine.stage.quality;
                                            GlobalEngine.stage.quality = GlobalEngine.STAGE_QUALITY_HIGH;
                                        };
                                    };
                                    _local9 = new flash.geom.Matrix(1, 0, 0, 1, Math.ceil(-(_local4.x)), Math.ceil(-(_local4.y)));
                                    _local7.lock();
                                    _local7.fillRect(_local7.rect, 0);
                                    _local7.draw(this.m_skeletonSprite, _local9, null, null, null, s_drawWithSmoothing);
                                    _local7.unlock();
                                    if (_local8 != null){
                                        GlobalEngine.stage.quality = _local8;
                                    };
                                    _local3.data = _local7;
                                    _local3.x = Math.floor(_local4.x);
                                    _local3.y = Math.floor(_local4.y);
                                    _local3.dirty = false;
                                } else {
                                    _local3.data = null;
                                    _local3.x = 0;
                                    _local3.y = 0;
                                    _local3.dirty = false;
                                };
                            };
                            AnimatedPuppet.addFrameCacheObject(_local3);
                            if (s_frameCacheNumBytes > FRAME_CACHE_CLEANUP_THRESHOLD){
                                AnimatedPuppet.cleanupAnimFrameCache();
                            };
                            this.m_cachedBitmap.bitmapData = _local3.data;
                            if (this.m_cachedBitmap.bitmapData){
                                if (this.m_flipped){
                                    this.m_cachedBitmap.scaleX = -1;
                                    this.m_cachedBitmap.x = -(_local3.x);
                                    this.m_cachedBitmap.y = _local3.y;
                                } else {
                                    this.m_cachedBitmap.scaleX = 1;
                                    this.m_cachedBitmap.x = _local3.x;
                                    this.m_cachedBitmap.y = _local3.y;
                                };
                            };
                            if (_local3 != this.m_currentCacheObject){
                                if (this.m_currentCacheObject){
                                    _local11 = this.m_currentCacheObject.bitmaps.indexOf(this.m_cachedBitmap);
                                    if (_local11 >= 0){
                                        this.m_currentCacheObject.bitmaps.splice(_local11, 1);
                                    };
                                };
                                this.m_currentCacheObject = _local3;
                                this.m_currentCacheObject.bitmaps.push(this.m_cachedBitmap);
                            };
                        } else {
                            this.m_skeleton.updateJoints(this.m_flipped);
                            this.m_skeleton.renderSkinSprite(this.m_skeletonSprite, false);
                        };
                    };
                } else {
                    this.m_sprite.graphics.beginFill(0, 0);
                    this.m_sprite.graphics.drawRect(0, 0, 1, 1);
                    this.m_sprite.graphics.endFill();
                };
                this.m_dirty = false;
            };
        }
        public function getInstance():IVisualComponent{
            var _local2:String;
            var _local3:uint;
            var _local1:AnimatedPuppet = new AnimatedPuppet();
            _local1.m_skinURL = this.m_skinURL;
            _local1.m_skin = this.m_skin;
            _local1.m_archetype = this.m_archetype;
            _local1.m_archetypeURL = this.m_archetypeURL;
            _local1.m_defaultAnimation = this.m_defaultAnimation;
            _local1.m_name = this.m_name;
            _local1.m_flipped = this.m_flipped;
            _local1.m_globalColors[0] = this.m_globalColors[0];
            _local1.m_globalColors[1] = this.m_globalColors[1];
            _local1.m_globalColors[2] = this.m_globalColors[2];
            _local1.m_template = this;
            _local1.m_cachedFrames = this.m_cachedFrames;
            _local1.m_categoryColors = {};
            for (_local2 in this.m_categoryColors) {
                _local1.m_categoryColors[_local2] = _local1.m_categoryColors[_local2];
            };
            _local1.m_attachments = new Array(this.m_attachments.length);
            _local3 = 0;
            while (_local3 < this.m_attachments.length) {
                _local1.m_attachments[_local3] = this.m_attachments[_local3].clone();
                _local3++;
            };
            _local1.m_hiddenAttachments = new Array(this.m_hiddenAttachments.length);
            _local3 = 0;
            while (_local3 < this.m_hiddenAttachments.length) {
                _local1.m_hiddenAttachments[_local3] = this.m_hiddenAttachments[_local3].clone();
                _local3++;
            };
            _local1.loadAssets();
            return (_local1);
        }
        public function update(_arg1:Number):Boolean{
            if (this.m_destroyed){
                return (false);
            };
            var _local2:Boolean;
            if (this.m_animClipInstance){
                if ((((this.m_durationLimit > 0)) && (((this.m_durationLimitTimer + _arg1) >= this.m_durationLimit)))){
                    _local2 = this.m_animClipInstance.update((this.m_durationLimit - this.m_durationLimitTimer));
                    this.m_animClipInstance.stop();
                    this.m_animClipInstance = null;
                    dispatchEvent(new flash.events.Event(ANIMATION_COMPLETE));
                } else {
                    this.m_durationLimitTimer = (this.m_durationLimitTimer + _arg1);
                    _local2 = this.m_animClipInstance.update(_arg1);
                    if (!this.m_animClipInstance.playing()){
                        this.m_animClipInstance = null;
                        dispatchEvent(new flash.events.Event(ANIMATION_COMPLETE));
                    };
                };
            };
            if (this.m_animClipInstance == null){
                this.startDefaultAnimation(false);
            };
            this.m_dirty = ((this.m_dirty) || (_local2));
            return (this.m_dirty);
        }
        public function hasAnimation(_arg1:String):Boolean{
            if (((((((this.m_archetype) && (this.m_archetype.loaded))) && (this.m_archetype.animationLibrary))) && (_arg1))){
                return (!((this.m_archetype.animationLibrary.getAnimationClip(_arg1) == null)));
            };
            return (false);
        }
        public function animationDuration(_arg1:String):Number{
            var _local3:ZDallasLib.Avatar2.GameAnimationClip;
            var _local2:Number = -1;
            if (((((((this.m_archetype) && (this.m_archetype.loaded))) && (this.m_archetype.animationLibrary))) && (_arg1))){
                _local3 = this.m_archetype.animationLibrary.getAnimationClip(_arg1);
                if (_local3){
                    _local2 = _local3.durationInSecs;
                };
            };
            return (_local2);
        }
        public function disableAnimFrameCache():void{
            if (this.m_cachedBitmap.parent == this.m_sprite){
                this.m_sprite.removeChild(this.m_cachedBitmap);
            };
            this.m_cachedFramesEnabled = false;
            this.m_sprite.addChild(this.m_skeletonSprite);
        }
        public function enableAnimFrameCache():void{
            if (this.m_skeletonSprite.parent == this.m_sprite){
                this.m_sprite.removeChild(this.m_skeletonSprite);
            };
            this.m_cachedFramesEnabled = true;
            this.m_sprite.addChild(this.m_cachedBitmap);
        }
        public function markFrameCacheAsDirty():void{
            var _local1:String;
            var _local2:Vector.<Object>;
            var _local3:uint;
            var _local4:Object;
            if (this.m_cachedFrames){
                for (_local1 in this.m_cachedFrames) {
                    _local2 = this.m_cachedFrames[_local1];
                    _local3 = 0;
                    while (_local3 < _local2.length) {
                        _local4 = _local2[_local3];
                        if (_local4){
                            _local4.dirty = true;
                        };
                        _local3++;
                    };
                };
            };
        }
        public function playAnimation(_arg1:String, _arg2:Number=0, _arg3:String=null):ZDallasLib.Avatar2.GameAnimationClipInstance{
            var _local5:ZDallasLib.Avatar2.GameAnimationClip;
            var _local6:Boolean;
            if (this.m_destroyed){
                return (null);
            };
            if (((this.m_animClipInstance) && ((this.m_animClipInstance.name == _arg1)))){
                return (this.m_animClipInstance);
            };
            var _local4:Number = ((((this.m_animClipInstance) && ((_arg3 == "continueLoop")))) ? this.m_animClipInstance.position : 0);
            if (this.m_animClipInstance){
                this.m_animClipInstance = null;
            };
            this.m_dirty = true;
            this.m_durationLimit = _arg2;
            this.m_durationLimitTimer = 0;
            if (((((((((this.m_archetype) && (this.m_archetype.loaded))) && (this.m_archetype.animationLibrary))) && (this.m_skeleton))) && (_arg1))){
                if (!(_arg1 in this.m_cachedAnimClipInstances)){
                    _local5 = this.m_archetype.animationLibrary.getAnimationClip(_arg1);
                    if (_local5){
                        this.m_animClipInstance = new ZDallasLib.Avatar2.GameAnimationClipInstance(_local5, this.m_skeleton);
                        this.m_animClipInstance.registerTriggerListener(null, null, this.onAnimationTriggerFired);
                        this.m_cachedAnimClipInstances[_arg1] = this.m_animClipInstance;
                    };
                } else {
                    this.m_animClipInstance = (this.m_cachedAnimClipInstances[_arg1] as ZDallasLib.Avatar2.GameAnimationClipInstance);
                    this.m_animClipInstance.stop();
                    this.m_animClipInstance.reset();
                };
                if (this.m_animClipInstance){
                    if (this.m_cachedFramesEnabled){
                        this.m_cachedFrames[this.m_animClipInstance.name] = ((this.m_cachedFrames[this.m_animClipInstance.name]) || (new Vector.<Object>((int((this.m_animClipInstance.fps * this.m_animClipInstance.duration)) + 1))));
                    };
                    if (this.m_disableTriggers){
                        this.m_animClipInstance.disableTriggers();
                    } else {
                        this.m_animClipInstance.enableTriggers();
                    };
                    _local6 = (((((((_arg3 == null)) && (_local5.isLooping))) || ((_arg3 == "continueLoop")))) || ((_arg3 == "loop")));
                    if (_arg3 == "continueLoop"){
                        if (!this.m_disableTriggers){
                            this.m_animClipInstance.disableTriggers();
                        };
                        this.m_animClipInstance.play(_local6, false);
                        this.m_animClipInstance.update(_local4);
                        if (!this.m_disableTriggers){
                            this.m_animClipInstance.enableTriggers();
                        };
                    } else {
                        this.m_animClipInstance.play(_local6, (_arg3 == "hold"));
                    };
                    if ((((_arg2 > 0)) && ((_arg3 == "scale")))){
                        this.m_animClipInstance.timeScale = (this.m_animClipInstance.duration / _arg2);
                    };
                };
            };
            this.updateDisplayObject();
            return (this.m_animClipInstance);
        }
        public function get isLoaded():Boolean{
            return ((((((((((this.m_skin == null)) || (this.m_skin.loaded))) && (this.m_archetype))) && (this.m_archetype.loaded))) && (this.hasLoadedAllAttachments)));
        }
        public function get isLoading():Boolean{
            return (((((((this.m_skin) && (this.m_skin.loading))) || (((this.m_archetype) && (this.m_archetype.loading))))) || (this.isLoadingAttachments)));
        }
        public function loadFromXML(_arg1:XML):void{
            var _local2:XML;
            var _local3:Array;
            var _local4:AnimatedPuppetAttachment;
            var _local5:String;
            this.m_skinURL = _arg1.@skin;
            this.m_archetypeURL = _arg1.@archetype;
            if (("@defaultAnimation" in _arg1)){
                this.m_defaultAnimation = _arg1.@defaultAnimation;
            };
            if (("@forceZsciSpriteSheet" in _arg1)){
                this.m_forceZsciSpriteSheet = !((_arg1.@forceZsciSpriteSheet.toString() == "false"));
            };
            for each (_local2 in _arg1.attachment) {
                if (("@skinURL" in _local2)){
                    _local3 = ((("@partList" in _local2)) ? _local2.@partList.toString().split(/ +/) : null);
                    _local4 = new AnimatedPuppetAttachment(_local2.@skinURL.toString(), _local3);
                    _local4.useSkeletonScale = !((_local2.@useSkeletonScale.toString() == "false"));
                    for each (_local5 in _local2.@category.toString().split(/ +/)) {
                        _local4.addToCategory(_local5);
                    };
                    this.addAttachment(_local4);
                    if (_local2.@visible.toString() == "false"){
                        this.hideAttachment(_local4);
                    };
                };
            };
            this.m_cacheFramesPerInstance = !((_arg1.@cacheFramesPerInstance.toString() == "false"));
        }
        public function get skeleton():ZDallasLib.Avatar2.Skeleton{
            return (this.m_skeleton);
        }
        public function loadAssets(_arg1:uint=15):void{
            var _local2:AnimatedPuppetAttachment;
            if (this.m_destroyed){
                return;
            };
            if (this.isLoaded){
                this.onAssetsLoaded();
            } else {
                this.m_loadingPriority = _arg1;
                if (this.m_archetype == null){
                    this.m_archetype = ZDallasLib.Avatar2.ArchetypeManager.loadArchetypeFromURL(this.m_archetypeURL, _arg1);
                };
                if (((this.m_skinURL) && ((this.m_skin == null)))){
                    this.m_skin = ZDallasLib.Avatar2.SkinManager.loadSkinFromURL(this.m_skinURL, _arg1, this.m_forceZsciSpriteSheet);
                };
                for each (_local2 in this.m_attachments) {
                    _local2.forceZsciSpriteSheet = this.m_forceZsciSpriteSheet;
                    _local2.loadAssets(_arg1);
                };
                for each (_local2 in this.m_hiddenAttachments) {
                    _local2.forceZsciSpriteSheet = this.m_forceZsciSpriteSheet;
                    _local2.loadAssets(_arg1);
                };
                if (this.isLoaded){
                    this.onAssetsLoaded();
                } else {
                    if (!this.m_archetype.loaded){
                        this.m_archetype.addEventListener(flash.events.Event.COMPLETE, this.onArchetypeLoaded);
                    };
                    if (((this.m_skin) && (!(this.m_skin.loaded)))){
                        this.m_skin.addEventListener(flash.events.Event.COMPLETE, this.onSkinLoaded);
                    };
                    for each (_local2 in this.m_attachments) {
                        if (!_local2.isLoaded){
                            _local2.addEventListener(flash.events.Event.COMPLETE, this.onAttachmentLoaded);
                        };
                    };
                    for each (_local2 in this.m_hiddenAttachments) {
                        if (!_local2.isLoaded){
                            _local2.addEventListener(flash.events.Event.COMPLETE, this.onAttachmentLoaded);
                        };
                    };
                };
            };
        }
        private function onSkinLoaded(_arg1:flash.events.Event=null):void{
            if (this.isLoaded){
                this.onAssetsLoaded();
            };
        }
        private function onArchetypeLoaded(_arg1:flash.events.Event=null):void{
            if (this.isLoaded){
                this.onAssetsLoaded();
            };
        }
        private function onAttachmentLoaded(_arg1:flash.events.Event=null):void{
            if (this.isLoaded){
                this.onAssetsLoaded();
            };
        }
        private function onAssetsLoaded():void{
            if (this.m_destroyed){
                return;
            };
            if (this.m_skeleton == null){
                this.m_skeleton = new ZDallasLib.Avatar2.Skeleton();
                this.m_skeleton.initSkeleton(this.m_archetype.skeleton.byteArray);
                if (this.m_skin){
                    this.m_skeleton.applySkin(this.m_skin);
                };
            };
            this.cleanupAssetLoadListeners();
            this.refreshAttachments();
            this.markFrameCacheAsDirty();
            if (this.m_animClipInstance == null){
                this.startDefaultAnimation();
            };
            this.updateDisplayObject(true);
            dispatchEvent(new flash.events.Event(ASSETS_LOADED));
        }
        private function startDefaultAnimation(_arg1:Boolean=true):void{
            var _local2 = !(this.m_disableTriggers);
            this.disableTriggers();
            this.playAnimation(this.m_defaultAnimation, 0, "loop");
            if (((this.m_animClipInstance) && (_arg1))){
                this.m_animClipInstance.update((Math.random() * this.m_animClipInstance.duration));
            };
            if (_local2){
                this.enableTriggers();
            };
        }
        private function onAnimationTriggerFired(_arg1:ZDallasLib.Avatar2.AnimationTriggerEvent):void{
            dispatchEvent(new ZDallasLib.Avatar2.AnimationTriggerEvent(_arg1.type, _arg1.triggerData, this));
        }
        private function clearAnimFrameCache():void{
            var _local1:String;
            var _local2:Object;
            for (_local1 in this.m_cachedFrames) {
                for each (_local2 in this.m_cachedFrames[_local1]) {
                    AnimatedPuppet.deleteFrameCacheObject(_local2);
                };
            };
        }
        private function cleanupAssetLoadListeners():void{
            var _local1:AnimatedPuppetAttachment;
            if (this.m_archetype){
                this.m_archetype.removeEventListener(flash.events.Event.COMPLETE, this.onArchetypeLoaded);
            };
            if (this.m_skin){
                this.m_skin.removeEventListener(flash.events.Event.COMPLETE, this.onSkinLoaded);
            };
            for each (_local1 in this.m_attachments) {
                _local1.removeEventListener(flash.events.Event.COMPLETE, this.onAttachmentLoaded);
            };
            for each (_local1 in this.m_hiddenAttachments) {
                _local1.removeEventListener(flash.events.Event.COMPLETE, this.onAttachmentLoaded);
            };
        }
        public function destroy():void{
            var _local1:int;
            if (this.m_currentCacheObject){
                _local1 = this.m_currentCacheObject.bitmaps.indexOf(this.m_cachedBitmap);
                if (_local1 >= 0){
                    this.m_currentCacheObject.bitmaps.splice(_local1, 1);
                };
            };
            if (this.m_template == null){
                this.clearAnimFrameCache();
            };
            if (this.m_animClipInstance){
                this.m_animClipInstance.stop();
                this.m_animClipInstance = null;
            };
            this.cleanupAssetLoadListeners();
            this.m_currentCacheObject = null;
            this.m_destroyed = true;
        }
    }
}//package ZDallasLib.Visual
