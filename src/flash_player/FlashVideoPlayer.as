﻿package {import flash.display.*;import flash.media.*;import flash.net.*;import flash.errors.*;import flash.system.Security;import flash.events.*;import paella.IMediaElement;import paella.External;import paella.JavascriptTrace;import paella.JavascriptInterface;import paella.VideoElement;import flash.external.ExternalInterface;import flash.text.*;	public class FlashVideoPlayer extends Sprite {	var _javascriptInterface:JavascriptInterface;	var _autoplay:Boolean = false;	var _timerRate:Number = 150;	var _startVolume:Number = 1.0;	var _streamer:String = "";		var _mediaElement:IMediaElement;	var _video:DisplayObject;		var _liveStream:Boolean;	var _bufferTime:Number;	var _url:String;	var _playerId:String;		var _debugMode:Boolean;	var _debuggerText:TextField;		public function FlashVideoPlayer() {		stage.scaleMode = StageScaleMode.NO_SCALE;		stage.align = StageAlign.TOP_LEFT;				_javascriptInterface = new JavascriptInterface();				this.registerExternalInterface();				addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);				loadFlashVars();				if (checkParameters()) {			if (_debugMode) {				buildDebugger();			}					this._javascriptInterface.playerId = this._playerId;			var videoElem:VideoElement = new VideoElement(_javascriptInterface, this._url, _autoplay, _startVolume, _bufferTime);			_mediaElement = videoElem;			_video = (_mediaElement as VideoElement).video;			_video.width = stage.stageWidth;			_video.height = stage.stageHeight;			stage.addEventListener(Event.RESIZE, onResize);			(_mediaElement as VideoElement).setReference(this);			addChild(_video);			if (_debugMode) {				addChild(_debuggerText);			}			if (_liveStream) {				JavascriptTrace.debug("Buffer time: " + _bufferTime);			}		}	}		private function buildDebugger() {		_debuggerText = new TextField();		_debuggerText.x = 0;		_debuggerText.y = 0;		_debuggerText.width = stage.stageWidth;		_debuggerText.height = stage.stageHeight;		_debuggerText.text = "";		JavascriptTrace.debugText = _debuggerText;	}		private function added(evt:Event):void {		loaderAnimation.x = stage.stageWidth / 2;		loaderAnimation.y = stage.stageHeight / 2;	}		private function loadFlashVars():void {		this._liveStream = stage.loaderInfo.parameters.isLiveStream=="true" ? true:false;		this._bufferTime = stage.loaderInfo.parameters.bufferTime===undefined ? 0:Number(stage.loaderInfo.parameters.bufferTime);		this._playerId = stage.loaderInfo.parameters.playerId===undefined ? "":stage.loaderInfo.parameters.playerId;		this._url = stage.loaderInfo.parameters.url===undefined ? "":stage.loaderInfo.parameters.url;		this._debugMode = stage.loaderInfo.parameters.debugMode=="true" ? true:false;		this._autoplay = this._liveStream ? true:(stage.loaderInfo.parameters.autoplay=="true" ? true:false);		var connect:String = stage.loaderInfo.parameters.connect;		if (connect) {			this._url = connect + this._url;		}	}		private function checkParameters():Boolean {		var status:Boolean = true;		if (this._url=="") {			status = false;			JavascriptTrace.error("Video URL not specified");		}		if (this._playerId=="") {			JavascriptTrace.warning("No player identifier specified");		}		return status;	}		private function registerExternalInterface():void {		paella.External.addCallback("log",paella.JavascriptTrace.log);		paella.External.addCallback("error",paella.JavascriptTrace.error);		paella.External.addCallback("warning",paella.JavascriptTrace.warning);		paella.External.addCallback("debug",paella.JavascriptTrace.debug);				paella.External.addCallback("pause",this.pauseVideo);		paella.External.addCallback("play",this.playVideo);		paella.External.addCallback("seekToTime",this.seekToTime);		paella.External.addCallback("seekTo",this.seekTo);		paella.External.addCallback("isReady",this.isReady);		paella.External.addCallback("duration",this.getDuration);		paella.External.addCallback("getCurrentTime",this.getCurrentTime);		paella.External.addCallback("getWidth",this.getWidth);		paella.External.addCallback("getHeight",this.getHeight);		paella.External.addCallback("getVolume",this.getVolume);		paella.External.addCallback("setVolume",this.setVolume);				paella.External.addCallback("currentProgress",this.currentProgress);				paella.External.addCallback("setTrimming",this.setTrimming);		paella.External.addCallback("enableTrimming",this.enableTrimming);		paella.External.addCallback("disableTrimming",this.disableTrimming);			}		public function onResize(event:Event):void {		_video.width = stage.stageWidth;		_video.height = stage.stageHeight;		loaderAnimation.x = stage.stageWidth / 2;		loaderAnimation.y = stage.stageHeight / 2;		if (_debuggerText) {			_debuggerText.width = stage.stageWidth;			_debuggerText.height = stage.stageHeight;		}	}	public function pauseVideo():void {		if (!_liveStream) {			this._mediaElement.pause();		}	}		public function playVideo():void {		if (!_liveStream) {			this._mediaElement.play();		}	}		public function seekToTime(pos:Number):void {		if (!_liveStream) {			this._mediaElement.setCurrentTime(pos);		}	}		public function seekTo(percent:Number):void {		var time:Number = percent * this._mediaElement.duration() / 100;		seekToTime(time);	}		public function isReady():Boolean {		// TODO: Implement this		return true;	}		public function getDuration():Number {		return this._mediaElement.duration();	}		public function getCurrentTime():Number {		return this._mediaElement.currentTime();	}		public function getWidth():Number {		return this._mediaElement.videoWidth;	}		public function getHeight():Number {		return this._mediaElement.videoHeight;	}		public function getVolume():Number {		return this._mediaElement.getVolume();	}		public function setVolume(vol:Number):void {		this._mediaElement.setVolume(vol);	}		public function currentProgress():Number {		return this._mediaElement.currentProgress();	}		public function setTrimming(trim:Number):void {		JavascriptTrace.debug("setTrimming(" + trim + "): not implemented");	}		public function enableTrimming():void {		JavascriptTrace.debug("enableTrimming(): not implemented");	}		public function disableTrimming():void {		JavascriptTrace.debug("disableTrimming(): not implemented");	}}}