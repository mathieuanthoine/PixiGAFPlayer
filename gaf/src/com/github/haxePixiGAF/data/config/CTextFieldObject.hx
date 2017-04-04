package com.github.haxePixiGAF.data.config;
import pixi.core.math.Point;

/**
 * TODO
 * @author Mathieu Anthoine
 * @private
 */
class CTextFieldObject
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
	private var _width:Float;
	private var _height:Float;
	private var _text:String;
	private var _embedFonts:Bool;
	private var _multiline:Bool;
	private var _wordWrap:Bool;
	private var _restrict:String;
	private var _editable:Bool;
	private var _selectable:Bool;
	private var _displayAsPassword:Bool;
	private var _maxChars:Int;
	//private var _textFormat:TextFormat;
	private var _pivotPoint:Point;

	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------

	public function new(id:String, text:String, textFormat/*:TextFormat*/, width:Float,
									 height:Float)
	{
		_id=id;
		_text=text;
		//_textFormat=textFormat;

		_width=width;
		_height=height;

		_pivotPoint=new Point();
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

	public var id(get_id, set_id):String;
 	private function get_id():String
	{
		return _id;
	}

	private function set_id(value:String):String
	{
		return _id=value;
	}

	public var text(get_text, set_text):String;
 	private function get_text():String
	{
		return _text;
	}

	private function set_text(value:String):String
	{
		return _text=value;
	}

	//public var textFormat(get_text, set_text):String;
 	//private function get_textFormat():TextFormat
	//{
		//return _textFormat;
	//}
//
	//private function set_textFormat(value:TextFormat):TextFormat
	//{
		//return _textFormat=value;
	//}

	public var width(get_width, set_width):Float;
 	private function get_width():Float
	{
		return _width;
	}

	private function set_width(value:Float):Float
	{
		return _width=value;
	}

	public var height(get_height, set_height):Float;
 	private function get_height():Float
	{
		return _height;
	}

	private function set_height(value:Float):Float
	{
		return _height=value;
	}

	//--------------------------------------------------------------------------
	//
	//  STATIC METHODS
	//
	//--------------------------------------------------------------------------

	public var embedFonts(get_embedFonts, set_embedFonts):Bool;
 	private function get_embedFonts():Bool
	{
		return _embedFonts;
	}

	private function set_embedFonts(value:Bool):Bool
	{
		return _embedFonts=value;
	}

	public var multiline(get_multiline, set_multiline):Bool;
 	private function get_multiline():Bool
	{
		return _multiline;
	}

	private function set_multiline(value:Bool):Bool
	{
		return _multiline=value;
	}

	public var wordWrap(get_wordWrap, set_wordWrap):Bool;
 	private function get_wordWrap():Bool
	{
		return _wordWrap;
	}

	private function set_wordWrap(value:Bool):Bool
	{
		return _wordWrap=value;
	}

	public var restrict(get_restrict, set_restrict):String;
 	private function get_restrict():String
	{
		return _restrict;
	}

	private function set_restrict(value:String):String
	{
		return _restrict=value;
	}

	public var editable(get_editable, set_editable):Bool;
 	private function get_editable():Bool
	{
		return _editable;
	}

	private function set_editable(value:Bool):Bool
	{
		return _editable=value;
	}

	public var selectable(get_selectable, set_selectable):Bool;
 	private function get_selectable():Bool
	{
		return _selectable;
	}

	private function set_selectable(value:Bool):Bool
	{
		return _selectable=value;
	}

	public var displayAsPassword(get_displayAsPassword, set_displayAsPassword):Bool;
 	private function get_displayAsPassword():Bool
	{
		return _displayAsPassword;
	}

	private function set_displayAsPassword(value:Bool):Bool
	{
		return _displayAsPassword=value;
	}

	public var maxChars(get_maxChars, set_maxChars):Int;
 	private function get_maxChars():Int
	{
		return _maxChars;
	}

	private function set_maxChars(value:Int):Int
	{
		return _maxChars=value;
	}

	public var pivotPoint(get_pivotPoint, set_pivotPoint):Point;
 	private function get_pivotPoint():Point
	{
		return _pivotPoint;
	}

	private function set_pivotPoint(value:Point):Point
	{
		return _pivotPoint=value;
	}
}