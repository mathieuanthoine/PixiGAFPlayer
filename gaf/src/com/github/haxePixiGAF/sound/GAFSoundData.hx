package com.github.haxePixiGAF.sound;

import com.github.haxePixiGAF.data.config.CSound;
import com.github.haxePixiGAF.utils.GAFBytesInput;


/**
 * TODO
 * @author Mathieu Anthoine
 *
 * 
 */
class GAFSoundData
{
	private var onFail:Void->Void;
	private var onSuccess:Void->Void;
	private var _sounds:Dynamic;
	private var _soundQueue:Array<CSound>;

	//public function getSoundByLinkage(linkage:String):Sound
	//{
		//if(_sounds)
		//{
			//return _sounds[linkage];
		//}
		//return null;
	//}

	/*gaf_private*/ public function addSound(soundData:CSound, swfName:String, soundBytes:GAFBytesInput):Void
	{
		//var sound:Sound=new Sound();
		//if(soundBytes)
		//{
			//if(soundBytes.position>0)
			//{
				//soundData.sound=_sounds[soundData.linkageName];
				//return;
			//}
			//else
			//{
				//sound.loadCompressedDataFromByteArray(soundBytes, soundBytes.length);
			//}
		//}
		//else
		//{
			//_soundQueue ||=new Array<CSound>();
			//_soundQueue.push(soundData);
		//}
//
		//soundData.sound=sound;
//
		//_sounds ||={};
		//if(soundData.linkageName.length>0)
		//{
			//_sounds[soundData.linkageName]=sound;
		//}
		//else
		//{
			//_sounds[swfName] ||={};
			//_sounds[swfName][soundData.soundID]=sound;
		//}
	}
//
	//gaf_private function getSound(soundID:Int, swfName:String):Sound
	//{
		//if(_sounds)
		//{
			//return _sounds[swfName][soundID];
		//}
		//return null;
	//}
//
	//gaf_private function loadSounds(onSuccess:Function, onFail:Function):Void
	//{
		//onSuccess=onSuccess;
		//onFail=onFail;
		//loadSound();
	//}
//
	//gaf_private function dispose():Void
	//{
		//for(var sound:Sound in _sounds)
		//{
			//sound.close();
		//}
	//}
//
	//private function loadSound():Void
	//{
		//var soundDataConfig:CSound=_soundQueue.pop();
		//with(soundDataConfig.sound)
		//{
			//addEventListener(Event.COMPLETE, onSoundLoaded);
			//addEventListener(IOErrorEvent.IO_ERROR, onError);
			//load(new URLRequest(soundDataConfig.source));
		//}
	//}
//
	//private function onSoundLoaded(event:Event):Void
	//{
		//removeListeners(event);
//
		//if(_soundQueue.length>0)
		//{
			//loadSound();
		//}
		//else
		//{
			//onSuccess();
			//onSuccess=null;
			//onFail=null;
		//}
	//}
//
	//private function onError(event:IOErrorEvent):Void
	//{
		//removeListeners(event);
		//onFail(event);
		//onFail=null;
		//onSuccess=null;
	//}
//
	//private function removeListeners(event:Event):Void
	//{
		//var sound:Sound=event.target as Sound;
		//sound.removeEventListener(Event.COMPLETE, onSoundLoaded);
		//sound.removeEventListener(IOErrorEvent.IO_ERROR, onError);
	//}
//
	//gaf_private function get hasSoundsToLoad():Bool
	//{
		//return _soundQueue && _soundQueue.length>0;
	//}
}