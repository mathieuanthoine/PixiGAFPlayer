package com.github.haxePixiGAF.data.config;


/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * Data object that describe sequence
 */
class CAnimationSequence
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
	private var _startFrameNo:Int;
	private var _endFrameNo:Int;

	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------

	/**
	 * 
	 */
	public function new(id:String, startFrameNo:Int, endFrameNo:Int)
	{
		_id=id;
		_startFrameNo=startFrameNo;
		_endFrameNo=endFrameNo;
	}

	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------

	/**
	 * 
	 */
	public function isSequenceFrame(frameNo:Int):Bool
	{
		// first frame is "1" !!!

		if(frameNo>=_startFrameNo && frameNo<=_endFrameNo)
		{
			return true;
		}
		else
		{
			return false;
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

	/**
	 * Sequence ID
	 * @return Sequence ID
	 */
	public var id(get_id, null):String;
 	private function get_id():String
	{
		return _id;
	}

	/**
	 * Sequence start frame number
	 * @return Sequence start frame number
	 */
	public var startFrameNo(get_startFrameNo, null):Int;
 	private function get_startFrameNo():Int
	{
		return _startFrameNo;
	}

	/**
	 * Sequence end frame number
	 * @return Sequence end frame number
	 */
	public var endFrameNo(get_endFrameNo, null):Int;
 	private function get_endFrameNo():Int
	{
		return _endFrameNo;
	}

}