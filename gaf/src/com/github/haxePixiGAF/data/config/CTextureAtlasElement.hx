package com.github.haxePixiGAF.data.config;
import pixi.core.math.Matrix;
import pixi.core.math.shapes.Rectangle;

/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * @private
 */
class CTextureAtlasElement
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

	private var _id:String;
	private var _linkage:String;
	private var _atlasID:String;
	private var _region:Rectangle;
	private var _pivotMatrix:Matrix;
	private var _scale9Grid:Rectangle;
	private var _rotated:Bool;

	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------

	public function new(id:String, atlasID:String)
	{
		_id=id;
		_atlasID=atlasID;
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

	public var id(get_id, null):String;
 	private function get_id():String
	{
		return _id;
	}

	public var region(get_region, set_region):Rectangle;
 	private function get_region():Rectangle
	{
		return _region;
	}

	private function set_region(region:Rectangle):Rectangle
	{
		return _region=region;
	}

	public var pivotMatrix(get_pivotMatrix, set_pivotMatrix):Matrix;
 	private function get_pivotMatrix():Matrix
	{
		return _pivotMatrix;
	}

	private function set_pivotMatrix(pivotMatrix:Matrix):Matrix
	{
		return _pivotMatrix=pivotMatrix;
	}

	public var atlasID(get_atlasID, null):String;
 	private function get_atlasID():String
	{
		return _atlasID;
	}

	public var scale9Grid(get_scale9Grid, set_scale9Grid):Rectangle;
 	private function get_scale9Grid():Rectangle
	{
		return _scale9Grid;
	}

	private function set_scale9Grid(value:Rectangle):Rectangle
	{
		return _scale9Grid=value;
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

	public var rotated(get_rotated, set_rotated):Bool;
 	private function get_rotated():Bool
	{
		return _rotated;
	}

	private function set_rotated(value:Bool):Bool
	{
		return _rotated=value;
	}
}