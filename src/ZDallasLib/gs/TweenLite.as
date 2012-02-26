//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.gs{
    import flash.utils.Dictionary;
    import flash.display.Sprite;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.geom.ColorTransform;
    import flash.display.DisplayObject;
    import flash.media.SoundChannel;
    import flash.utils.*;

    public class TweenLite {

        public static var version:Number = 6.04;
        public static var killDelayedCallsTo:Function = killTweensOf;
        protected static var _all:flash.utils.Dictionary = new flash.utils.Dictionary();
        private static var _sprite:flash.display.Sprite = new flash.display.Sprite();
        private static var _listening:Boolean;
        private static var _timer:flash.utils.Timer = new flash.utils.Timer(2000);

        public var duration:Number;
        public var vars:Object;
        public var delay:Number;
        public var startTime:uint;
        public var initTime:uint;
        public var tweens:Object;
        public var target:Object;
        protected var _active:Boolean;
        protected var _subTweens:Array;
        protected var _hst:Boolean;
        protected var _initted:Boolean;

        public function TweenLite(_arg1:Object, _arg2:Number, _arg3:Object){
            if (_arg1 == null){
                return;
            };
            if (((((!((_arg3.overwrite == false))) && (!((_arg1 == null))))) || ((_all[_arg1] == undefined)))){
                delete _all[_arg1];
                _all[_arg1] = new flash.utils.Dictionary();
            };
            _all[_arg1][this] = this;
            this.vars = _arg3;
            this.duration = ((_arg2) || (0.001));
            this.delay = ((_arg3.delay) || (0));
            this.target = _arg1;
            if (!(this.vars.ease is Function)){
                this.vars.ease = easeOut;
            };
            if (this.vars.easeParams != null){
                this.vars.proxiedEase = this.vars.ease;
                this.vars.ease = this.easeProxy;
            };
            if (this.vars.mcColor != null){
                this.vars.tint = this.vars.mcColor;
            };
            if (!isNaN(Number(this.vars.autoAlpha))){
                this.vars.alpha = Number(this.vars.autoAlpha);
            };
            this.tweens = {};
            this._subTweens = [];
            this._hst = (this._initted = false);
            this._active = (((_arg2 == 0)) && ((this.delay == 0)));
            this.initTime = flash.utils.getTimer();
            if ((((((this.vars.runBackwards == true)) && (!((this.vars.renderOnStart == true))))) || (this._active))){
                this.initTweenVals();
                this.startTime = flash.utils.getTimer();
                if (this._active){
                    this.render((this.startTime + 1));
                } else {
                    this.render(this.startTime);
                };
            };
            if (((!(_listening)) && (!(this._active)))){
                _sprite.addEventListener(flash.events.Event.ENTER_FRAME, executeAll);
                _timer.addEventListener("timer", killGarbage);
                _timer.start();
                _listening = true;
            };
        }
        public static function to(_arg1:Object, _arg2:Number, _arg3:Object):TweenLite{
            return (new TweenLite(_arg1, _arg2, _arg3));
        }
        public static function from(_arg1:Object, _arg2:Number, _arg3:Object):TweenLite{
            _arg3.runBackwards = true;
            return (new TweenLite(_arg1, _arg2, _arg3));
        }
        public static function delayedCall(_arg1:Number, _arg2:Function, _arg3:Array=null, _arg4=null):TweenLite{
            return (new TweenLite(_arg2, 0, {
                delay:_arg1,
                onComplete:_arg2,
                onCompleteParams:_arg3,
                onCompleteScope:_arg4,
                overwrite:false
            }));
        }
        public static function executeAll(_arg1:flash.events.Event=null):void{
            var _local4:Object;
            var _local5:Object;
            var _local2:flash.utils.Dictionary = _all;
            var _local3:uint = flash.utils.getTimer();
            for (_local4 in _local2) {
                for (_local5 in _local2[_local4]) {
                    if (((!((_local2[_local4][_local5] == undefined))) && (_local2[_local4][_local5].active))){
                        _local2[_local4][_local5].render(_local3);
                        if (_local2[_local4] == undefined) break;
                    };
                };
            };
        }
        public static function removeTween(_arg1:TweenLite=null):void{
            if (((!((_arg1 == null))) && (!((_all[_arg1.target] == undefined))))){
                delete _all[_arg1.target][_arg1];
            };
        }
        public static function killTweensOf(_arg1:Object=null, _arg2:Boolean=false):void{
            var _local3:Object;
            var _local4:*;
            if (((!((_arg1 == null))) && (!((_all[_arg1] == undefined))))){
                if (_arg2){
                    _local3 = _all[_arg1];
                    for (_local4 in _local3) {
                        _local3[_local4].complete(false);
                    };
                };
                delete _all[_arg1];
            };
        }
        public static function killGarbage(_arg1:flash.events.TimerEvent):void{
            var _local3:Boolean;
            var _local4:Object;
            var _local5:Object;
            var _local6:Object;
            var _local2:uint;
            for (_local4 in _all) {
                _local3 = false;
                for (_local5 in _all[_local4]) {
                    _local3 = true;
                    break;
                };
                if (!_local3){
                    delete _all[_local4];
                } else {
                    _local2++;
                };
            };
            if (_local2 == 0){
                _sprite.removeEventListener(flash.events.Event.ENTER_FRAME, executeAll);
                _timer.removeEventListener("timer", killGarbage);
                _timer.stop();
                _listening = false;
            };
        }
        protected static function easeOut(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Number{
            _arg1 = (_arg1 / _arg4);
            return ((((-(_arg3) * _arg1) * (_arg1 - 2)) + _arg2));
        }
        public static function tintProxy(_arg1:Object):void{
            var _local2:Number = _arg1.target.progress;
            var _local3:Number = (1 - _local2);
            _arg1.info.target.transform.colorTransform = new flash.geom.ColorTransform(((_arg1.info.color.redMultiplier * _local3) + (_arg1.info.endColor.redMultiplier * _local2)), ((_arg1.info.color.greenMultiplier * _local3) + (_arg1.info.endColor.greenMultiplier * _local2)), ((_arg1.info.color.blueMultiplier * _local3) + (_arg1.info.endColor.blueMultiplier * _local2)), ((_arg1.info.color.alphaMultiplier * _local3) + (_arg1.info.endColor.alphaMultiplier * _local2)), ((_arg1.info.color.redOffset * _local3) + (_arg1.info.endColor.redOffset * _local2)), ((_arg1.info.color.greenOffset * _local3) + (_arg1.info.endColor.greenOffset * _local2)), ((_arg1.info.color.blueOffset * _local3) + (_arg1.info.endColor.blueOffset * _local2)), ((_arg1.info.color.alphaOffset * _local3) + (_arg1.info.endColor.alphaOffset * _local2)));
        }
        public static function frameProxy(_arg1:Object):void{
            _arg1.info.target.gotoAndStop(Math.round(_arg1.target.frame));
        }
        public static function volumeProxy(_arg1:Object):void{
            _arg1.info.target.soundTransform = _arg1.target;
        }

        public function initTweenVals(_arg1:Boolean=false, _arg2:String=""):void{
            var _local4:String;
            var _local5:Array;
            var _local6:int;
            var _local7:flash.geom.ColorTransform;
            var _local8:flash.geom.ColorTransform;
            var _local9:Object;
            var _local3 = (this.target is flash.display.DisplayObject);
            if ((this.target is Array)){
                _local5 = ((this.vars.endArray) || ([]));
                _local6 = 0;
                while (_local6 < _local5.length) {
                    if (((!((this.target[_local6] == _local5[_local6]))) && (!((this.target[_local6] == undefined))))){
                        this.tweens[_local6.AS3::toString()] = {
                            o:this.target,
                            p:_local6.AS3::toString(),
                            s:this.target[_local6],
                            c:(_local5[_local6] - this.target[_local6])
                        };
                    };
                    _local6++;
                };
            } else {
                for (_local4 in this.vars) {
                    if (!(((((((((((((((((((((((((((((((((((((_local4 == "ease")) || ((_local4 == "delay")))) || ((_local4 == "overwrite")))) || ((_local4 == "onComplete")))) || ((_local4 == "onCompleteParams")))) || ((_local4 == "onCompleteScope")))) || ((_local4 == "runBackwards")))) || ((_local4 == "onUpdate")))) || ((_local4 == "onUpdateParams")))) || ((_local4 == "onUpdateScope")))) || ((_local4 == "autoAlpha")))) || ((_local4 == "onStart")))) || ((_local4 == "onStartParams")))) || ((_local4 == "onStartScope")))) || ((_local4 == "renderOnStart")))) || ((_local4 == "easeParams")))) || ((_local4 == "mcColor")))) || ((_local4 == "type")))) || (((_arg1) && (!((_arg2.AS3::indexOf(((" " + _local4) + " ")) == -1))))))){
                        if ((((_local4 == "tint")) && (_local3))){
                            _local7 = this.target.transform.colorTransform;
                            _local8 = new flash.geom.ColorTransform();
                            if (this.vars.alpha != undefined){
                                _local8.alphaMultiplier = this.vars.alpha;
                                delete this.vars.alpha;
                                delete this.tweens.alpha;
                            } else {
                                _local8.alphaMultiplier = this.target.alpha;
                            };
                            if (((!((this.vars[_local4] == null))) && (!((this.vars[_local4] == ""))))){
                                _local8.color = this.vars[_local4];
                            };
                            this.addSubTween(tintProxy, {progress:0}, {progress:1}, {
                                target:this.target,
                                color:_local7,
                                endColor:_local8
                            });
                        } else {
                            if ((((_local4 == "frame")) && (_local3))){
                                this.addSubTween(frameProxy, {frame:this.target.currentFrame}, {frame:this.vars[_local4]}, {target:this.target});
                            } else {
                                if ((((_local4 == "volume")) && (((_local3) || ((this.target is flash.media.SoundChannel)))))){
                                    this.addSubTween(volumeProxy, this.target.soundTransform, {volume:this.vars[_local4]}, {target:this.target});
                                } else {
                                    if (this.target.AS3::hasOwnProperty(_local4)){
                                        if (typeof(this.vars[_local4]) == "number"){
                                            this.tweens[_local4] = {
                                                o:this.target,
                                                p:_local4,
                                                s:this.target[_local4],
                                                c:(this.vars[_local4] - this.target[_local4])
                                            };
                                        } else {
                                            this.tweens[_local4] = {
                                                o:this.target,
                                                p:_local4,
                                                s:this.target[_local4],
                                                c:Number(this.vars[_local4])
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            if (this.vars.runBackwards == true){
                for (_local4 in this.tweens) {
                    _local9 = this.tweens[_local4];
                    this.tweens[_local4].s = (_local9.s + _local9.c);
                    _local9.c = (_local9.c * -1);
                };
            };
            if (typeof(this.vars.autoAlpha) == "number"){
                this.target.visible = !((((this.vars.runBackwards == true)) && ((this.target.alpha == 0))));
            };
            this._initted = true;
        }
        protected function addSubTween(_arg1:Function, _arg2:Object, _arg3:Object, _arg4:Object=null):void{
            var _local5:String;
            this._subTweens.AS3::push({
                proxy:_arg1,
                target:_arg2,
                info:_arg4
            });
            for (_local5 in _arg3) {
                if (_arg2.AS3::hasOwnProperty(_local5)){
                    if (typeof(_arg3[_local5]) == "number"){
                        this.tweens[((("st" + this._subTweens.length) + "_") + _local5)] = {
                            o:_arg2,
                            p:_local5,
                            s:_arg2[_local5],
                            c:(_arg3[_local5] - _arg2[_local5])
                        };
                    } else {
                        this.tweens[((("st" + this._subTweens.length) + "_") + _local5)] = {
                            o:_arg2,
                            p:_local5,
                            s:_arg2[_local5],
                            c:Number(_arg3[_local5])
                        };
                    };
                };
            };
            this._hst = true;
        }
        public function render(_arg1:uint):void{
            var _local4:Object;
            var _local5:String;
            var _local6:uint;
            var _local2:Number = ((_arg1 - this.startTime) / 1000);
            if (_local2 > this.duration){
                _local2 = this.duration;
            };
            var _local3:Number = this.vars.ease(_local2, 0, 1, this.duration);
            for (_local5 in this.tweens) {
                _local4 = this.tweens[_local5];
                _local4.o[_local4.p] = (_local4.s + (_local3 * _local4.c));
            };
            if (this._hst){
                _local6 = 0;
                while (_local6 < this._subTweens.length) {
                    this._subTweens[_local6].proxy(this._subTweens[_local6]);
                    _local6++;
                };
            };
            if (this.vars.onUpdate != null){
                this.vars.onUpdate.apply(this.vars.onUpdateScope, this.vars.onUpdateParams);
            };
            if (_local2 == this.duration){
                this.complete(true);
            };
        }
        public function complete(_arg1:Boolean=false):void{
            if (!_arg1){
                if (!this._initted){
                    this.initTweenVals();
                };
                this.startTime = 0;
                this.render((this.duration * 1000));
                return;
            };
            if ((((typeof(this.vars.autoAlpha) == "number")) && ((this.target.alpha == 0)))){
                this.target.visible = false;
            };
            if (this.vars.onComplete != null){
                this.vars.onComplete.apply(this.vars.onCompleteScope, this.vars.onCompleteParams);
            };
            removeTween(this);
        }
        protected function easeProxy(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Number{
            return (this.vars.proxiedEase.apply(null, arguments.AS3::concat(this.vars.easeParams)));
        }
        public function get active():Boolean{
            if (this._active){
                return (true);
            };
            if (((flash.utils.getTimer() - this.initTime) / 1000) > this.delay){
                this._active = true;
                this.startTime = (this.initTime + (this.delay * 1000));
                if (!this._initted){
                    this.initTweenVals();
                } else {
                    if (typeof(this.vars.autoAlpha) == "number"){
                        this.target.visible = true;
                    };
                };
                if (this.vars.onStart != null){
                    this.vars.onStart.apply(this.vars.onStartScope, this.vars.onStartParams);
                };
                if (this.duration == 0.001){
                    this.startTime = (this.startTime - 1);
                };
                return (true);
            };
            return (false);
        }

    }
}//package ZDallasLib.gs
