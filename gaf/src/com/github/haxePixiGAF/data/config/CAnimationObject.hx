package com.github.haxePixiGAF.data.config;
import pixi.core.math.Point;

/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * 
 */
class CAnimationObject
{
	//--------------------------------------------------------------------------
	//
	//  PUBLIC VARIABLES
	//
	//--------------------------------------------------------------------------

	public static inline var TYPE_TEXTURE:String="texture";
	public static inline var TYPE_TEXTFIELD:String="textField";
	public static inline var TYPE_TIMELINE:String="timeline";

	//--------------------------------------------------------------------------
	//
	//  PRIVATE VARIABLES
	//
	//--------------------------------------------------------------------------

	private var _instanceID:String;
	private var _regionID:String;
	private var _type:String;
	private var _mask:Bool=false;
	private var _maxSize:Point;

	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------

	public function new(instanceID:String, regionID:String, type:String, mask:Bool)
	{
		_instanceID=instanceID;
		_regionID=regionID;
		_type=type;
		_mask=mask;
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

	//--------------------------------------------------------------------------
	//
	//  GETTERS AND SETTERS
	//
	//--------------------------------------------------------------------------

	public var instanceID(get_instanceID, null):String;
 	private function get_instanceID():String
	{
		return _instanceID;
	}

	public var regionID(get_regionID, null):String;
 	private function get_regionID():String
	{
		return _regionID;
	}

	public var mask(get_mask, null):Bool;
 	private function get_mask():Bool
	{
		return _mask;
	}

	public var type(get_type, null):String;
 	private function get_type():String
	{
		return _type;
	}

	public var maxSize(get_maxSize, set_maxSize):Point;
 	private function get_maxSize():Point
	{
		return _maxSize;
	}

	private function set_maxSize(value:Point):Point
	{
		return _maxSize=value;
	}
}