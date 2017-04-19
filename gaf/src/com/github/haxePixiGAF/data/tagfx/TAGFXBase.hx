package com.github.haxePixiGAF.data.tagfx;

import com.github.haxePixiGAF.data.textures.TextureWrapper;
import pixi.core.math.Point;
import pixi.core.textures.Texture;
import pixi.interaction.EventEmitter;

/**
 * Dispatched when he texture is decoded. It can only be used when the callback has been executed.
 */
//[Event(name="textureReady", type="flash.events.Event")]

/**
 * TODO
 * @author Mathieu Anthoine
 * @private
 */
class TAGFXBase extends EventEmitter implements ITAGFX
{
	//--------------------------------------------------------------------------
	//
	//  PUBLIC VARIABLES
	//
	//--------------------------------------------------------------------------

	public static inline var EVENT_TYPE_TEXTURE_READY:String="textureReady";

	public static inline var SOURCE_TYPE_BITMAP_DATA:String="sourceTypeBitmapData";
	public static inline var SOURCE_TYPE_BITMAP:String="sourceTypeBitmap";
	public static inline var SOURCE_TYPE_PNG_BA:String="sourceTypePNGBA";
	public static inline var SOURCE_TYPE_ATF_BA:String="sourceTypeATFBA";
	public static inline var SOURCE_TYPE_PNG_URL:String="sourceTypePNGURL";
	public static inline var SOURCE_TYPE_ATF_URL:String="sourceTypeATFURL";

	//--------------------------------------------------------------------------
	//
	//  PRIVATE VARIABLES
	//
	//--------------------------------------------------------------------------

	private var _texture:TextureWrapper;
	private var _textureSize:Point;
	private var _textureScale:Float=-1;
	private var _textureFormat:String;
	private var _source:Dynamic;
	private var _clearSourceAfterTextureCreated:Bool=false;
	private var _isReady:Bool=false;

	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------

	public function new()
	{
		super();
		//if(Capabilities.isDebugger &&
				//getQualifiedClassName(this)=="com.catalystapps.gaf.data::TAGFXBase")
		//{
			//throw new AbstractClassError();
		//}
	}

	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------

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

	private function onTextureReady(texture:TextureWrapper):Void
	{
		_isReady=true;
		//dispatchEvent(new Event(EVENT_TYPE_TEXTURE_READY));
		emit(EVENT_TYPE_TEXTURE_READY);
	}

	//--------------------------------------------------------------------------
	//
	//  GETTERS AND SETTERS
	//
	//--------------------------------------------------------------------------

	public var texture(get_texture, null):TextureWrapper;
 	private function get_texture():TextureWrapper
	{
		return _texture;
	}

	public var textureSize(get_textureSize, set_textureSize):Point;
 	private function get_textureSize():Point
	{
		return _textureSize;
	}

	private function set_textureSize(value:Point):Point
	{
		return _textureSize=value;
	}

	public var textureScale(get_textureScale, set_textureScale):Float;
 	private function get_textureScale():Float
	{
		return _textureScale;
	}

	private function set_textureScale(value:Float):Float
	{
		return _textureScale=value;
	}

	public var textureFormat(get_textureFormat, set_textureFormat):String;
 	private function get_textureFormat():String
	{
		return _textureFormat;
	}

	private function set_textureFormat(value:String):String
	{
		return _textureFormat=value;
	}

	public var sourceType(get_sourceType, null):String;
 	private function get_sourceType():String
	{
		//TODO
		//throw new AbstractMethodError();
		return "";
	}

	public var source(get_source, null):Dynamic;
 	private function get_source():Dynamic
	{
		return _source;
	}

	public var clearSourceAfterTextureCreated(get_clearSourceAfterTextureCreated, set_clearSourceAfterTextureCreated):Bool;
 	private function get_clearSourceAfterTextureCreated():Bool
	{
		return _clearSourceAfterTextureCreated;
	}

	private function set_clearSourceAfterTextureCreated(value:Bool):Bool
	{
		return _clearSourceAfterTextureCreated=value;
	}

	public var ready(get_ready, null):Bool;
 	private function get_ready():Bool
	{
		return _isReady;
	}

	//--------------------------------------------------------------------------
	//
	//  STATIC METHODS
	//
	//--------------------------------------------------------------------------
}