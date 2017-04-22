package com.github.haxePixiGAF.data;

import com.github.haxePixiGAF.data.config.CSound;
import com.github.haxePixiGAF.data.config.CStage;
import com.github.haxePixiGAF.data.config.CTextureAtlasScale;


/**
 * AS3 conversion
 * @author Mathieu Anthoine
 */
class GAFAssetConfig
{
	public static inline var MAX_VERSION:Int=5;

	private var _id:String;
	private var _compression:Int;
	private var _versionMajor:Int;
	private var _versionMinor:Int;
	private var _fileLength:Int;
	private var _scaleValues:Array<Float>;
	private var _csfValues:Array<Float>;
	private var _defaultScale:Float;
	private var _defaultContentScaleFactor:Float;

	private var _stageConfig:CStage;

	private var _timelines:Array<GAFTimelineConfig>;
	private var _allTextureAtlases:Array<CTextureAtlasScale>;
	private var _sounds:Array<CSound>;

	public function new(id:String)
	{
		_id=id;
		_scaleValues=new Array<Float>();
		_csfValues=new Array<Float>();

		_timelines=new Array<GAFTimelineConfig>();
		_allTextureAtlases=new Array<CTextureAtlasScale>();
	}

	public function addSound(soundData:CSound):Void
	{
		if (_sounds==null) _sounds =new Array<CSound>();
		_sounds.push(soundData);
	}

	public function dispose():Void
	{
		_allTextureAtlases=null;
		_stageConfig=null;
		_scaleValues=null;
		_csfValues=null;
		_timelines=null;
		_sounds=null;
	}

	public var compression(get_compression, set_compression):Int;
 	private function get_compression():Int
	{
		return _compression;
	}

	private function set_compression(value:Int):Int
	{
		return _compression=value;
	}

	public var versionMajor(get_versionMajor, set_versionMajor):Int;
 	private function get_versionMajor():Int
	{
		return _versionMajor;
	}

	private function set_versionMajor(value:Int):Int
	{
		return _versionMajor=value;
	}

	public var versionMinor(get_versionMinor, set_versionMinor):Int;
 	private function get_versionMinor():Int
	{
		return _versionMinor;
	}

	private function set_versionMinor(value:Int):Int
	{
		return _versionMinor=value;
	}

	public var fileLength(get_fileLength, set_fileLength):Int;
 	private function get_fileLength():Int
	{
		return _fileLength;
	}

	private function set_fileLength(value:Int):Int
	{
		return _fileLength=value;
	}

	public var scaleValues(get_scaleValues, null):Array<Float>;
 	private function get_scaleValues():Array<Float>
	{
		return _scaleValues;
	}

	public var csfValues(get_csfValues, null):Array<Float>;
 	private function get_csfValues():Array<Float>
	{
		return _csfValues;
	}

	public var defaultScale(get_defaultScale, set_defaultScale):Float;
 	private function get_defaultScale():Float
	{
		return _defaultScale;
	}

	private function set_defaultScale(value:Float):Float
	{
		return _defaultScale=value;
	}

	public var defaultContentScaleFactor(get_defaultContentScaleFactor, set_defaultContentScaleFactor):Float;
 	private function get_defaultContentScaleFactor():Float
	{
		return _defaultContentScaleFactor;
	}

	private function set_defaultContentScaleFactor(value:Float):Float
	{
		return _defaultContentScaleFactor=value;
	}

	public var timelines(get_timelines, null):Array<GAFTimelineConfig>;
 	private function get_timelines():Array<GAFTimelineConfig>
	{
		return _timelines;
	}

	public var allTextureAtlases(get_allTextureAtlases, null):Array<CTextureAtlasScale>;
 	private function get_allTextureAtlases():Array<CTextureAtlasScale>
	{
		return _allTextureAtlases;
	}

	public var stageConfig(get_stageConfig, set_stageConfig):CStage;
 	private function get_stageConfig():CStage
	{
		return _stageConfig;
	}

	private function set_stageConfig(value:CStage):CStage
	{
		return _stageConfig=value;
	}

	public var id(get_id, null):String;
 	private function get_id():String
	{
		return _id;
	}

	public var sounds(get_sounds, null):Array<CSound>;
 	private function get_sounds():Array<CSound>
	{
		return _sounds;
	}
}