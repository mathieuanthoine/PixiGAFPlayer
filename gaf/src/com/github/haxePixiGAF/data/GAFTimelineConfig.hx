package com.github.haxePixiGAF.data;

import com.github.haxePixiGAF.data.config.CAnimationFrames;
import com.github.haxePixiGAF.data.config.CAnimationObjects;
import com.github.haxePixiGAF.data.config.CAnimationSequences;
import com.github.haxePixiGAF.data.config.CStage;
import com.github.haxePixiGAF.data.config.CTextFieldObjects;
import com.github.haxePixiGAF.data.config.CTextureAtlasScale;
import com.github.haxePixiGAF.utils.MathUtility;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;

/**
 * TODO
 * @author Mathieu Anthoine
 */
class GAFTimelineConfig
{
	//--------------------------------------------------------------------------
	//
	//  PUBLIC VARIABLES
	//
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//
	//  PRIVATE VARIABLES
	//
	//--------------------------------------------------------------------------
	private var _version:String;
	private var _stageConfig:CStage;

	private var _id:String;
	private var _assetID:String;

	private var _allTextureAtlases:Array<CTextureAtlasScale>;
	private var _textureAtlas:CTextureAtlasScale;

	private var _animationConfigFrames:CAnimationFrames;
	private var _animationObjects:CAnimationObjects;
	private var _animationSequences:CAnimationSequences;
	private var _textFields:CTextFieldObjects;

	private var _namedParts:Map<String,String>;
	private var _linkage:String;

	private var _debugRegions:Array<GAFDebugInformation>;

	private var _warnings:Array<String>;
	private var _framesCount:Int;
	private var _bounds:Rectangle;
	private var _pivot:Point;
	//private var _sounds:Dictionary;
	private var _disposed:Bool;

	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------

	public function new(version:String)
	{
		_version=version;

		_animationConfigFrames=new CAnimationFrames();
		_animationObjects=new CAnimationObjects();
		_animationSequences=new CAnimationSequences();
		_textFields=new CTextFieldObjects();
		//_sounds=new Dictionary();
	}

	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------

	public function dispose():Void
	{
		for(cTextureAtlasScale in _allTextureAtlases)
		{
			cTextureAtlasScale.dispose();
		}
		_allTextureAtlases=null;

		_animationConfigFrames=null;
		_animationSequences=null;
		_animationObjects=null;
		_textureAtlas=null;
		_textFields=null;
		_namedParts=null;
		_warnings=null;
		_bounds=null;
		//_sounds=null;
		_pivot=null;
		
		_disposed=true;
	}

	public function getTextureAtlasForScale(scale:Float):CTextureAtlasScale
	{
		for(cTextureAtlas in _allTextureAtlases)
		{
			if(MathUtility.equals(cTextureAtlas.scale, scale))
			{
				return cTextureAtlas;
			}
		}

		return null;
	}

	//public function addSound(data:Dynamic, frame:Int):Void
	//{
		//_sounds[frame]=new CFrameSound(data);
	//}
//
	//public function getSound(frame:Int):CFrameSound
	//{
		//return _sounds[frame];
	//}

	public function addWarning(text:String):Void
	{
		if(text==null)
		{
			return;
		}

		if(_warnings==null)
		{
			_warnings=new Array<String>();
		}

		if(_warnings.indexOf(text)==-1)
		{
			trace(text);
			_warnings.push(text);
		}
	}

	public function getNamedPartID(name:String):String
	{
		for(id in _namedParts)
		{
			if(_namedParts[id]==name)
			{
				return id;
			}
		}
		return null;
	}

	//--------------------------------------------------------------------------
	//
	//  PRIVATE METHODS
	//
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//
	// OVERRIDDEN METHODS
	//
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//
	//  EVENT HANDLERS
	//
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//
	//  GETTERS AND SETTERS
	//
	//--------------------------------------------------------------------------

	public var textureAtlas(get_textureAtlas, set_textureAtlas):CTextureAtlasScale;
 	private function get_textureAtlas():CTextureAtlasScale
	{
		return _textureAtlas;
	}

	private function set_textureAtlas(textureAtlas:CTextureAtlasScale):CTextureAtlasScale
	{
		return _textureAtlas=textureAtlas;
	}

	public var animationObjects(get_animationObjects, set_animationObjects):CAnimationObjects;
 	private function get_animationObjects():CAnimationObjects
	{
		return _animationObjects;
	}

	private function set_animationObjects(animationObjects:CAnimationObjects):CAnimationObjects
	{
		return _animationObjects=animationObjects;
	}

	public var animationConfigFrames(get_animationConfigFrames, set_animationConfigFrames):CAnimationFrames;
 	private function get_animationConfigFrames():CAnimationFrames
	{
		return _animationConfigFrames;
	}

	private function set_animationConfigFrames(animationConfigFrames:CAnimationFrames):CAnimationFrames
	{
		return _animationConfigFrames=animationConfigFrames;
	}

	public var animationSequences(get_animationSequences, set_animationSequences):CAnimationSequences;
 	private function get_animationSequences():CAnimationSequences
	{
		return _animationSequences;
	}

	private function set_animationSequences(animationSequences:CAnimationSequences):CAnimationSequences
	{
		return _animationSequences=animationSequences;
	}

	public var textFields(get_textFields, set_textFields):CTextFieldObjects;
 	private function get_textFields():CTextFieldObjects
	{
		return _textFields;
	}

	private function set_textFields(textFields:CTextFieldObjects):CTextFieldObjects
	{
		return _textFields=textFields;
	}

	public var allTextureAtlases(get_allTextureAtlases, set_allTextureAtlases):Array<CTextureAtlasScale>;
 	private function get_allTextureAtlases():Array<CTextureAtlasScale>
	{
		return _allTextureAtlases;
	}

	private function set_allTextureAtlases(allTextureAtlases:Array<CTextureAtlasScale>):Array<CTextureAtlasScale>
	{
		return _allTextureAtlases=allTextureAtlases;
	}

	public var version(get_version, null):String;
 	private function get_version():String
	{
		return _version;
	}

	public var debugRegions(get_debugRegions, set_debugRegions):Array<GAFDebugInformation>;
 	private function get_debugRegions():Array<GAFDebugInformation>
	{
		return _debugRegions;
	}

	private function set_debugRegions(debugRegions:Array<GAFDebugInformation>):Array<GAFDebugInformation>
	{
		return _debugRegions=debugRegions;
	}

	public var warnings(get_warnings, null):Array<String>;
 	private function get_warnings():Array<String>
	{
		return _warnings;
	}

	public var id(get_id, set_id):String;
 	private function get_id():String
	{
		return _id;
	}

	private function set_id(value:String):String
	{
		return _id=value;
	}

	public var assetID(get_assetID, set_assetID):String;
 	private function get_assetID():String
	{
		return _assetID;
	}

	private function set_assetID(value:String):String
	{
		return _assetID=value;
	}

	public var namedParts(get_namedParts, set_namedParts):Map<String,String>;
 	private function get_namedParts():Map<String,String>
	{
		return _namedParts;
	}

	private function set_namedParts(value:Map<String,String>):Map<String,String>
	{
		return _namedParts=value;
	}

	public var linkage(get_linkage, set_linkage):String;
 	private function get_linkage():String
	{
		return _linkage;
	}

	private function set_linkage(value:String):String
	{
		return _linkage=value;
	}

	public var stageConfig(get_stageConfig, set_stageConfig):CStage;
 	private function get_stageConfig():CStage
	{
		return _stageConfig;
	}

	private function set_stageConfig(stageConfig:CStage):CStage
	{
		return _stageConfig=stageConfig;
	}

	public var framesCount(get_framesCount, set_framesCount):Int;
 	private function get_framesCount():Int
	{
		return _framesCount;
	}

	private function set_framesCount(value:Int):Int
	{
		return _framesCount=value;
	}

	public var bounds(get_bounds, set_bounds):Rectangle;
 	private function get_bounds():Rectangle
	{
		return _bounds;
	}

	private function set_bounds(value:Rectangle):Rectangle
	{
		return _bounds=value;
	}

	public var pivot(get_pivot, set_pivot):Point;
 	private function get_pivot():Point
	{
		return _pivot;
	}

	private function set_pivot(value:Point):Point
	{
		return _pivot=value;
	}

	public var disposed(get_disposed, null):Bool;
 	private function get_disposed():Bool {
		return _disposed;
	}
}