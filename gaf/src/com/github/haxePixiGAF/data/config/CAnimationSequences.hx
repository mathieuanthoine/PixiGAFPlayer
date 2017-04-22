package com.github.haxePixiGAF.data.config;


/**
 * AS3 conversion
 * @author Mathieu Anthoine
 * 
 */
class CAnimationSequences
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

	private var _sequences:Array<CAnimationSequence>;

	private var _sequencesStartDictionary:Dynamic;
	private var _sequencesEndDictionary:Dynamic;

	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------

	public function new()
	{
		_sequences=new Array<CAnimationSequence>();

		_sequencesStartDictionary={};
		_sequencesEndDictionary={};
	}

	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------

	public function addSequence(sequence:CAnimationSequence):Void
	{
		_sequences.push(sequence);

		if(!_sequencesStartDictionary[sequence.startFrameNo])
		{
			_sequencesStartDictionary[sequence.startFrameNo]=sequence;
		}

		if(!_sequencesEndDictionary[sequence.endFrameNo])
		{
			_sequencesEndDictionary[sequence.endFrameNo]=sequence;
		}
	}

	public function getSequenceStart(frameNo:Int):CAnimationSequence
	{
		return _sequencesStartDictionary[frameNo];
	}

	public function getSequenceEnd(frameNo:Int):CAnimationSequence
	{
		return _sequencesEndDictionary[frameNo];
	}

	public function getStartFrameNo(sequenceID:String):Int
	{
		var result:Int=0;

		for(sequence in _sequences)
		{
			if(sequence.id==sequenceID)
			{
				return sequence.startFrameNo;
			}
		}

		return result;
	}

	public function getSequenceByID(id:String):CAnimationSequence
	{
		for(sequence in _sequences)
		{
			if(sequence.id==id)
			{
				return sequence;
			}
		}

		return null;
	}

	public function getSequenceByFrame(frameNo:Int):CAnimationSequence
	{
		for(i in 0..._sequences.length)
		{
			if(_sequences[i].isSequenceFrame(frameNo))
			{
				return _sequences[i];
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

	public var sequences(get_sequences, null):Array<CAnimationSequence>;
 	private function get_sequences():Array<CAnimationSequence>
	{
		return _sequences;
	}

}