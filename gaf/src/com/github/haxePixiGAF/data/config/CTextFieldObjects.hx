package com.github.haxePixiGAF.data.config;

/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * 
 */
class CTextFieldObjects
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

	private var _textFieldObjectsDictionary:Map<String,CTextFieldObject>;

	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------

	public function new()
	{
		_textFieldObjectsDictionary=new Map<String,CTextFieldObject>();
	}

	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------

	public function addTextFieldObject(textFieldObject:CTextFieldObject):Void
	{
		if(_textFieldObjectsDictionary[textFieldObject.id]==null)
		{
			_textFieldObjectsDictionary[textFieldObject.id]=textFieldObject;
		}
	}

	public function getAnimationObject(id:String):CAnimationObject
	{
		if(_textFieldObjectsDictionary[id]!=null)
		{
			return cast(_textFieldObjectsDictionary[id],CAnimationObject);
		}
		else
		{
			return null;
		}
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

	public var textFieldObjectsDictionary(get_textFieldObjectsDictionary, null):Map<String,CTextFieldObject>;
 	private function get_textFieldObjectsDictionary():Map<String,CTextFieldObject>
	{
		return _textFieldObjectsDictionary;
	}

	//--------------------------------------------------------------------------
	//
	//  STATIC METHODS
	//
	//--------------------------------------------------------------------------

}