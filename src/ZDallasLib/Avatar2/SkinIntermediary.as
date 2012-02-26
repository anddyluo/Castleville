//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Avatar2{
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import flash.net.URLLoader;
    import flash.display.Loader;
    import flash.utils.ByteArray;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import flash.geom.Vector3D;
    import flash.display.BitmapData;
    import flash.events.IOErrorEvent;
    import flash.utils.Endian;
    import flash.geom.Point;
    import flash.display.Bitmap;
    import __AS3__.vec.*;
	import __AS3__.vec.Vector;
	
	import Engine.Classes.URLResourceLoader;
	import Engine.Classes.ResourceLoader;
	import Engine.Managers.LoadingManager;
    public class SkinIntermediary extends flash.events.EventDispatcher {

        private static var m_pathToLoaderMap:flash.utils.Dictionary = new flash.utils.Dictionary();

        private var m_name:String;
        private var m_assetBase:String = "";
        private var m_skinContainers:Vector.<SkinContainer>;
        private var m_loadingImages:flash.utils.Dictionary;
        private var m_loaders:flash.utils.Dictionary;
        private var m_numImagesLoaded:int = 0;
        private var m_numImagesToLoad:int = 0;
        private var m_translateImageUrls:Boolean = true;
        private var m_assetPackageName:String;
        private var m_assetPackageLoader:flash.net.URLLoader;
        private var m_spriteSheetName:String;
        private var m_spriteSheetLoader:flash.display.Loader;
        private var m_spriteSheetMap:flash.utils.Dictionary;
        private var m_loaded:Boolean = false;
        private var m_loading:Boolean = false;
        private var m_loadFailed:Boolean = false;
        private var m_loadingAssets:Boolean = false;
        private var m_loadingPriority:uint = 10;
        public var forceSpriteSheetToZsci:Boolean = true;

        public function SkinIntermediary(){
            this.m_skinContainers = new Vector.<SkinContainer>();
            this.m_loadingImages = new flash.utils.Dictionary();
            this.m_loaders = new flash.utils.Dictionary();
            this.m_spriteSheetMap = new flash.utils.Dictionary();
            super();
        }
        public static function clearImageCache():void{
            m_pathToLoaderMap = new flash.utils.Dictionary();
        }

        public function get loaded():Boolean{
            return (this.m_loaded);
        }
        public function get loading():Boolean{
            return (this.m_loading);
        }
        public function get loadFailed():Boolean{
            return (this.m_loadFailed);
        }
        public function get skinContainers():Vector.<SkinContainer>{
            return (this.m_skinContainers);
        }
        public function get name():String{
            return (this.m_name);
        }
        public function get assetBase():String{
            return (this.m_assetBase);
        }
        public function set assetBase(_arg1:String):void{
            this.m_assetBase = new String(_arg1);
        }
        public function get assetPackageName():String{
            return (this.m_assetPackageName);
        }
        public function set assetPackageName(_arg1:String):void{
            this.m_assetPackageName = _arg1;
        }
        public function get spriteSheetName():String{
            return (this.m_spriteSheetName);
        }
        public function set spriteSheetName(_arg1:String):void{
            this.m_spriteSheetName = _arg1;
        }
        public function get spriteSheetMap():flash.utils.Dictionary{
            return (this.m_spriteSheetMap);
        }
        public function clearSpriteSheetMap():void{
            this.m_spriteSheetMap = new flash.utils.Dictionary();
        }
        public function get loadingPriority():int{
            return (this.m_loadingPriority);
        }
        public function set loadingPriority(_arg1:int):void{
            this.m_loadingPriority = _arg1;
        }
        public function set translateImageUrls(_arg1:Boolean):void{
            this.m_translateImageUrls = _arg1;
        }
        public function get translateImageUrls():Boolean{
            return (this.m_translateImageUrls);
        }
        public function getSkinContainerByName(_arg1:String):SkinContainer{
            var _local2:SkinContainer;
            for each (_local2 in this.skinContainers) {
                if (_local2.m_name == _arg1){
                    return (_local2);
                };
            };
            return (null);
        }
        public function load(_arg1:String, _arg2:uint=15):void{
            this.m_name = new String(_arg1);
            this.loadASC(_arg1, _arg2);
        }
        private function loadASC(_arg1:String, _arg2:uint=15):void{
            this.m_loading = true;
            this.m_loadingPriority = _arg2;
            var _local3:Object = new Object();
            _local3.completeCallback = this.ascLoaded;
            _local3.memoryLoadCallback = this.onMemoryLoad;
            _local3.faultCallback = this.ascLoadFailed;
            _local3.priority = _arg2;
            _local3.resourceLoaderClass = Engine.Classes.URLResourceLoader;
            Engine.Managers.LoadingManager.loadFromUrl(GlobalEngine.getAssetUrl(new String(_arg1)), _local3);
        }
        private function onMemoryLoad(_arg1:flash.utils.ByteArray):void{
            var _local2:XML = XML(_arg1);
            this.loadFromXML(_local2);
        }
        private function ascLoaded(_arg1:flash.events.Event, _arg2:String):void{
            var _local3:flash.net.URLLoader = (_arg1.currentTarget as flash.net.URLLoader);
            _local3.removeEventListener(flash.events.Event.COMPLETE, this.ascLoaded);
            var _local4:XML = XML(_arg1.target.data);
            this.loadFromXML(_local4);
        }
        private function ascLoadFailed(_arg1:flash.events.Event):void{
            this.m_loadFailed = true;
            this.onAssetsLoaded();
        }
        public function asXML():XML{
            var _local2:SkinContainer;
            var _local3:String;
            var _local4:flash.geom.Rectangle;
            var _local5:XML;
            var _local6:Vector.<Vector3D>;
            var _local7:XML;
            var _local8:uint;
            var _local9:XML;
            var _local1:XML = <AvatarSkinContainer/>
            ;
            if (this.m_assetPackageName){
                _local1.@assetPackage = this.m_assetPackageName;
            };
            if (((this.m_spriteSheetName) && (this.m_spriteSheetMap))){
                _local1.spriteSheet = new XML((('<spriteSheet url="' + this.m_spriteSheetName.AS3::replace(".zsci", ".png")) + '"/>'));
                for (_local3 in this.m_spriteSheetMap) {
                    _local4 = this.m_spriteSheetMap[_local3];
                    _local5 = new XML((((((((((('<sprite name="' + _local3) + '" x="') + _local4.x) + '" y="') + _local4.y) + '" width="') + _local4.width) + '" height="') + _local4.height) + '"/>'));
                    _local1.spriteSheet.appendChild(_local5);
                };
            };
            for each (_local2 in this.m_skinContainers) {
                _local6 = _local2.m_Mat3D.decompose();
                _local7 = <ascNode/>
                ;
                _local7.@name = _local2.m_name;
                _local7.jointName = <jointName/>
                ;
                _local7.jointName.@cname = _local2.m_jointName;
                _local7.transform = <transform/>
                ;
                _local7.transform.translation = ((((_local6[0].x + " ") + _local6[0].y) + " ") + _local6[0].z);
                _local7.transform.rotation = ((((_local6[1].x + " ") + _local6[1].y) + " ") + _local6[1].z);
                _local7.transform.scale = ((((_local6[2].x + " ") + _local6[2].y) + " ") + _local6[2].z);
                _local7.transform.forceWidth = _local2.m_width;
                _local7.transform.forceHeight = _local2.m_height;
                _local7.images = <images/>
                ;
                if (_local2.m_sequenceAttributeName){
                    _local7.images.@sequenceAttribute = _local2.m_sequenceAttributeName;
                };
                _local8 = 0;
                while (_local8 < _local2.m_imageName.length) {
                    _local9 = <image/>
                    ;
                    if (_local2.m_imageName[_local8]){
                        _local9.@url = _local2.m_imageName[_local8];
                        if (((_local2.m_colorMaskImageName[_local8]) && (!((_local2.m_colorMaskImageName[_local8] == ""))))){
                            _local9.@colorMaskUrl = _local2.m_colorMaskImageName[_local8];
                        };
                        if (_local2.m_cropSourceRect[_local8]){
                            _local9.cropSourceRect = [_local2.m_cropSourceRect[_local8].x, _local2.m_cropSourceRect[_local8].y, _local2.m_cropSourceRect[_local8].width, _local2.m_cropSourceRect[_local8].height].AS3::join(" ");
                        };
                    };
                    _local7.images.appendChild(_local9);
                    _local8++;
                };
                _local1.appendChild(_local7);
            };
            return (_local1);
        }
        public function loadFromXML(_arg1:XML, _arg2:Boolean=true):void{
            var _local6:XML;
            var _local7:SkinContainer;
            var _local8:String;
            var _local9:XML;
            var _local10:Array;
            var _local11:Array;
            var _local12:Array;
            var _local13:flash.geom.Vector3D;
            var _local14:flash.geom.Vector3D;
            var _local15:flash.geom.Vector3D;
            var _local16:String;
            var _local17:String;
            var _local18:int;
            var _local19:XMLList;
            var _local20:uint;
            var _local21:XML;
            var _local22:Array;
            this.m_loading = true;
            var _local3:XMLList = _arg1.child("ascNode");
            if (("@assetPackage" in _arg1)){
                this.m_assetPackageName = _arg1.@assetPackage.toString();
            };
            if (("spriteSheet" in _arg1)){
                this.m_spriteSheetMap = new flash.utils.Dictionary();
                this.m_spriteSheetName = _arg1.spriteSheet.@url.toString();
                for each (_local6 in _arg1.spriteSheet.sprite) {
                    this.m_spriteSheetMap[_local6.@name.toString()] = new flash.geom.Rectangle(Number(_local6.@x), Number(_local6.@y), Number(_local6.@width), Number(_local6.@height));
                };
            };
            this.m_numImagesToLoad = 0;
            var _local4:int = _local3.length();
            var _local5:int;
            while (_local5 < _local4) {
                _local7 = new SkinContainer();
                _local8 = _local3[_local5].jointName.@cname.toString().toLowerCase();
                _local7.m_jointName = _local8;
                _local7.m_name = _local3[_local5].@name;
                _local9 = _local3[_local5].transform[0];
                _local10 = _local9.rotation.toString().split(" ");
                _local11 = _local9.translation.toString().split(" ");
                _local12 = _local9.scale.toString().split(" ");
                _local13 = new flash.geom.Vector3D(Number(_local10[0]), Number(_local10[1]), Number(_local10[2]));
                _local14 = new flash.geom.Vector3D(Number(_local11[0]), Number(_local11[1]), Number(_local11[2]));
                _local15 = new flash.geom.Vector3D(Number(_local12[0]), Number(_local12[1]), Number(_local12[2]));
				//生成显示对象的转换矩阵
                _local7.m_Mat3D.recompose(Vector.<flash.geom.Vector3D>([_local14, _local13, _local15]));
                _local7.m_width = Number(_local9.forceWidth.toString());
                _local7.m_height = Number(_local9.forceHeight.toString());
                if (("front" in _local3[_local5])){
                    _local7.m_imageName = new Vector.<String>(SkinContainer.NUM_IMAGE_ORIENTATIONS);
                    _local7.m_bitmapData = new Vector.<flash.display.BitmapData>(SkinContainer.NUM_IMAGE_ORIENTATIONS);
                    _local7.m_cropSourceRect = new Vector.<flash.geom.Rectangle>(SkinContainer.NUM_IMAGE_ORIENTATIONS);
                    _local7.m_colorMaskBitmapData = new Vector.<flash.display.BitmapData>(SkinContainer.NUM_IMAGE_ORIENTATIONS);
                    _local7.m_colorMaskImageName = new Vector.<String>(SkinContainer.NUM_IMAGE_ORIENTATIONS);
                    _local7.m_tmpColorMaskBitmapData = new Vector.<flash.display.BitmapData>(SkinContainer.NUM_IMAGE_ORIENTATIONS);
                    _local16 = "";
                    _local17 = "";
                    if (_local3[_local5].front.@image.toString().length > 0){
                        _local7.m_imageName[SkinContainer.IMAGE_FRONT] = _local3[_local5].front.@image;
                        if (_local3[_local5].front.hasOwnProperty("cropSourceRect")){
                            _local22 = _local3[_local5].front.cropSourceRect.toString().split(" ");
                            _local7.m_cropSourceRect[SkinContainer.IMAGE_FRONT] = new flash.geom.Rectangle(Number(_local22[0]), Number(_local22[1]), Number(_local22[2]), Number(_local22[3]));
                        } else {
                            _local7.m_cropSourceRect[SkinContainer.IMAGE_FRONT] = null;
                        };
                    };
                    if (_local3[_local5].back.@image.toString().length > 0){
                        _local7.m_imageName[SkinContainer.IMAGE_BACK] = _local3[_local5].back.@image;
                        if (_local3[_local5].back.hasOwnProperty("cropSourceRect")){
                            _local22 = _local3[_local5].back.cropSourceRect.toString().split(" ");
                            _local7.m_cropSourceRect[SkinContainer.IMAGE_BACK] = new flash.geom.Rectangle(Number(_local22[0]), Number(_local22[1]), Number(_local22[2]), Number(_local22[3]));
                        } else {
                            _local7.m_cropSourceRect[SkinContainer.IMAGE_BACK] = null;
                        };
                    };
                } else {
                    _local18 = _local3[_local5].images.image.length();
                    _local7.m_imageName = new Vector.<String>(_local18, true);
                    _local7.m_bitmapData = new Vector.<flash.display.BitmapData>(_local18, true);
                    _local7.m_cropSourceRect = new Vector.<flash.geom.Rectangle>(_local18, true);
                    _local7.m_colorMaskBitmapData = new Vector.<flash.display.BitmapData>(_local18, true);
                    _local7.m_colorMaskImageName = new Vector.<String>(_local18, true);
                    _local7.m_tmpColorMaskBitmapData = new Vector.<flash.display.BitmapData>(_local18, true);
                    if (("@sequenceAttribute" in _local3[_local5].images[0])){
                        _local7.m_sequenceAttributeName = _local3[_local5].images[0].@sequenceAttribute.toString().toLowerCase();
                    };
                    _local19 = _local3[_local5].images.image;
                    _local20 = 0;
                    while (_local20 < _local18) {
                        _local21 = _local19[_local20];
                        _local7.m_imageName[_local20] = ((("@url" in _local21)) ? _local21.@url.toString() : null);
                        _local7.m_colorMaskImageName[_local20] = ((("@colorMaskUrl" in _local21)) ? _local21.@colorMaskUrl.toString() : null);
                        if (("cropSourceRect" in _local21)){
                            _local22 = _local21.cropSourceRect.toString().split(" ");
                            _local7.m_cropSourceRect[_local20] = new flash.geom.Rectangle(Number(_local22[0]), Number(_local22[1]), Number(_local22[2]), Number(_local22[3]));
                        };
                        _local20++;
                    };
                };
                this.m_skinContainers.AS3::push(_local7);
                _local5++;
            };
            if (_arg2){
                this.loadAssets();
            };
        }
        public function loadAssets():void{
            var _local1:String;
            var _local2:String;
            var _local3:SkinContainer;
            var _local4:Vector.<String>;
            var _local5:String;
            var _local6:Object;
            var _local7:String;
            var _local8:Object;
            var _local9:Object;
            if (((((!(this.m_loaded)) && (!(this.m_loadingAssets)))) && ((this.m_skinContainers.length > 0)))){
                this.m_numImagesToLoad = 0;
                this.m_numImagesLoaded = 0;
                this.m_loadingAssets = true;
                for each (_local3 in this.m_skinContainers) {
                    _local4 = _local3.m_imageName.AS3::concat(_local3.m_colorMaskImageName);
                    for each (_local2 in _local4) {
                        if (((!((_local2 == null))) && (!((_local2 == ""))))){
                            if (this.m_assetPackageName){
                                _local1 = _local2;
                            } else {
                                if (this.m_translateImageUrls){
                                    _local1 = GlobalEngine.getAssetUrl((this.assetBase + _local2));
                                } else {
                                    _local1 = (this.assetBase + _local2);
                                };
                            };
                            if (this.m_loadingImages[_local2] == null){
                                this.m_loadingImages[_local2] = _local1;
                            };
                            if (!(_local1 in this.m_loaders)){
                                this.m_loaders[_local1] = null;
                                this.m_numImagesToLoad++;
                            };
                        };
                    };
                };
                if (this.m_assetPackageName){
                    _local5 = GlobalEngine.getAssetUrl((this.assetBase + this.m_assetPackageName));
                    _local6 = {
                        resourceLoaderClass:Engine.Classes.URLResourceLoader,
                        memoryLoadCallback:this.onAssetPackageLoadedFromMemory,
                        completeCallback:this.onAssetPackageLoaded,
                        faultCallback:this.onAssetPackageLoadFailed,
                        priority:this.m_loadingPriority
                    };
                    this.m_assetPackageLoader = Engine.Managers.LoadingManager.loadFromUrl(_local5, _local6);
                } else {
                    if (this.m_spriteSheetName){
                        if (this.forceSpriteSheetToZsci){
                            this.m_spriteSheetName = this.m_spriteSheetName.AS3::replace(".png", ".zsci");
                        };
                        _local7 = GlobalEngine.getAssetUrl((this.assetBase + this.m_spriteSheetName));
                        _local8 = {
                            resourceLoaderClass:Engine.Classes.ResourceLoader,
                            priority:this.m_loadingPriority,
                            completeCallback:this.onSpriteSheetLoaded,
                            faultCallback:this.onSpriteSheetLoadFailed
                        };
                        this.m_spriteSheetLoader = Engine.Managers.LoadingManager.loadFromUrl(_local7, _local8);
                    } else {
                        for (_local2 in this.m_loaders) {
                            _local9 = {
                                resourceLoaderClass:Engine.Classes.ResourceLoader,
                                priority:this.m_loadingPriority,
                                completeCallback:this.onImageLoaded,
                                faultCallback:this.onImageLoadFailed
                            };
                            this.m_loaders[_local2] = Engine.Managers.LoadingManager.loadFromUrl(_local2, _local9);
                        };
                    };
                };
            };
        }
        private function onAssetPackageLoaded(_arg1:flash.events.Event, _arg2:String):void{
            this.onAssetPackageLoadedFromMemory(this.m_assetPackageLoader.data);
            this.m_assetPackageLoader = null;
        }
        private function onAssetPackageLoadFailed(_arg1:flash.events.IOErrorEvent):void{
            this.m_loadFailed = true;
            this.onAssetsLoaded();
        }
        private function onAssetsLoaded():void{
            var _local2:SkinContainer;
            var _local3:Boolean;
            var _local4:int;
            var _local1:int = (this.m_skinContainers.length - 1);
            while (_local1 >= 0) {
                _local2 = this.m_skinContainers[_local1];
                _local3 = true;
                _local4 = 0;
                while (_local4 < _local2.m_bitmapData.length) {
                    if (_local2.m_bitmapData[_local4]){
                        _local3 = false;
                        break;
                    };
                    _local4++;
                };
                if (_local3){
                    this.m_skinContainers.AS3::splice(_local1, 1);
                };
                _local1--;
            };
            this.cleanupTempData();
            this.m_loaded = !(this.m_loadFailed);
            this.m_loading = false;
            this.m_loadingAssets = false;
            if (this.m_loadFailed){
                dispatchEvent(new flash.events.IOErrorEvent(flash.events.IOErrorEvent.IO_ERROR));
            } else {
                dispatchEvent(new flash.events.Event(flash.events.Event.COMPLETE));
            };
        }
        private function onAssetPackageLoadedFromMemory(_arg1:flash.utils.ByteArray):void{
            var _local3:flash.display.Loader;
            var _local5:uint;
            var _local7:String;
            var _local8:uint;
            var _local9:uint;
            var _local10:flash.utils.ByteArray;
            _arg1.endian = flash.utils.Endian.BIG_ENDIAN;
            _arg1.position = 0;
            var _local2:uint = 1;
            if (_arg1.readUTFBytes(4) == "ascp"){
                _local2 = _arg1.readUnsignedInt();
            } else {
                _arg1.position = 0;
            };
            var _local4:Array = [];
            var _local6:uint = _arg1.readUnsignedInt();
            _local5 = 0;
            while (_local5 < _local6) {
                _local7 = _arg1.readUTF();
                _local8 = _arg1.readUnsignedInt();
                _local9 = _arg1.readUnsignedInt();
                _local4.AS3::push({
                    name:_local7,
                    dataOffset:_local8,
                    dataLength:_local9
                });
                _local3 = new flash.display.Loader();
                _local3.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, this.onImageLoaded);
                _local3.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onImageLoadFailed);
                this.m_loaders[_local7] = _local3;
                _local5++;
            };
            _local5 = 0;
            while (_local5 < _local6) {
                _local10 = new flash.utils.ByteArray();
                _arg1.readBytes(_local10, 0, _local4[_local5].dataLength);
                _local3 = this.m_loaders[_local4[_local5].name];
                _local3.loadBytes(_local10);
                _local5++;
            };
        }
        private function onSpriteSheetLoaded(_arg1:flash.events.Event=null):void{
            var _local3:flash.display.BitmapData;
            var _local4:flash.geom.Point;
            var _local5:String;
            var _local6:flash.geom.Rectangle;
            var _local7:flash.display.BitmapData;
            var _local8:SkinContainer;
            var _local9:uint;
            var _local2:flash.display.Bitmap = (this.m_spriteSheetLoader.content as flash.display.Bitmap);
            if (_local2){
                _local3 = _local2.bitmapData;
                _local4 = new flash.geom.Point(0, 0);
                for (_local5 in this.m_spriteSheetMap) {
                    _local6 = this.m_spriteSheetMap[_local5];
                    _local7 = new flash.display.BitmapData(_local6.width, _local6.height, true, 0);
                    _local7.copyPixels(_local3, _local6, _local4);
                    for each (_local8 in this.m_skinContainers) {
                        _local9 = 0;
                        while (_local9 < _local8.m_imageName.length) {
                            if (_local8.m_imageName[_local9] == _local5){
                                _local8.m_bitmapData[_local9] = _local7;
                            };
                            if (_local8.m_colorMaskImageName[_local9] == _local5){
                                _local8.m_colorMaskBitmapData[_local9] = _local7;
                                _local8.m_tmpColorMaskBitmapData[_local9] = _local7.clone();
                            };
                            _local9++;
                        };
                    };
                };
            };
            this.onAssetsLoaded();
        }
        private function onSpriteSheetLoadFailed(_arg1:flash.events.Event=null):void{
            var _local2:String;
            var _local3:Object;
            if (this.m_spriteSheetName.AS3::indexOf("zsci") != -1){
                _local2 = GlobalEngine.getAssetUrl((this.assetBase + this.m_spriteSheetName.AS3::replace(".zsci", ".png")));
                _local3 = {
                    resourceLoaderClass:Engine.Classes.ResourceLoader,
                    priority:this.m_loadingPriority,
                    completeCallback:this.onSpriteSheetLoaded,
                    faultCallback:this.onSpriteSheetLoadFailed
                };
                this.m_spriteSheetLoader = Engine.Managers.LoadingManager.loadFromUrl(_local2, _local3);
            } else {
                this.m_loadFailed = true;
                this.onAssetsLoaded();
            };
        }
        private function onImageLoadFailed(_arg1:flash.events.Event):void{
            trace("Image load failed");
            this.m_loadFailed = true;
            this.onImageLoaded();
        }
        private function onImageLoaded(_arg1:flash.events.Event=null):void{
            var _local2:String;
            var _local3:flash.display.Loader;
            var _local4:SkinContainer;
            var _local5:uint;
            this.m_numImagesLoaded++;
            if (this.m_numImagesLoaded == this.m_numImagesToLoad){
                for (_local2 in this.m_loadingImages) {
                    _local3 = this.m_loaders[this.m_loadingImages[_local2]];
                    if (_local3){
                        for each (_local4 in this.m_skinContainers) {
                            _local5 = 0;
                            while (_local5 < _local4.m_imageName.length) {
                                if ((((_local4.m_imageName[_local5] == _local2)) && ((_local3.content is flash.display.Bitmap)))){
                                    _local4.m_bitmapData[_local5] = (_local3.content as flash.display.Bitmap).bitmapData;
                                };
                                _local5++;
                            };
                            _local5 = 0;
                            while (_local5 < _local4.m_colorMaskImageName.length) {
                                if ((((_local4.m_colorMaskImageName[_local5] == _local2)) && ((_local3.content is flash.display.Bitmap)))){
                                    _local4.m_colorMaskBitmapData[_local5] = (_local3.content as flash.display.Bitmap).bitmapData;
                                    _local4.m_tmpColorMaskBitmapData[_local5] = (_local3.content as flash.display.Bitmap).bitmapData.clone();
                                };
                                _local5++;
                            };
                        };
                    };
                };
                this.onAssetsLoaded();
            };
        }
        private function cleanupTempData():void{
            while (this.m_loadingImages.length) {
                this.m_loadingImages.pop();
            };
            if (this.m_spriteSheetLoader){
                this.m_spriteSheetLoader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, this.onSpriteSheetLoaded);
                this.m_spriteSheetLoader.contentLoaderInfo.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onSpriteSheetLoadFailed);
                this.m_spriteSheetLoader = null;
            };
            if (this.m_assetPackageLoader){
                this.m_assetPackageLoader.removeEventListener(flash.events.Event.COMPLETE, this.onAssetPackageLoaded);
                this.m_assetPackageLoader.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onAssetPackageLoadFailed);
                this.m_assetPackageLoader = null;
            };
        }

    }
}//package ZDallasLib.Avatar2
