package com.github.haxePixiGAF.data.config;


/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * @private
 */
class CAnimationObjects
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

	private var _animationObjectsDictionary:Map<String,CAnimationObject>;

	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------

	public function new()
	{
		_animationObjectsDictionary=new Map<String,CAnimationObject>();
	}

	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------

	public function addAnimationObject(animationObject:CAnimationObject):Void
	{
		if(_animationObjectsDictionary[animationObject.instanceID]==null)
		{
			_animationObjectsDictionary[animationObject.instanceID]=animationObject;
		}
	}

	public function getAnimationObject(instanceID:String):CAnimationObject
	{
		if(_animationObjectsDictionary[instanceID]!=null)
		{
			return _animationObjectsDictionary[instanceID];
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

	public var animationObjectsDictionary(get_animationObjectsDictionary, null):Map<String,CAnimationObject>;
 	private function get_animationObjectsDictionary():Map<String,CAnimationObject>
	{
		return _animationObjectsDictionary;
	}

}