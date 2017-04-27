/**
 * Created by Nazar on 27.11.2014.
 */
/****************************************************************************
 This is the helper class for Slot Machine reel

  / \
 | A |
 |---|
 | B |
 |---|
 | C |
  \ /

 http://gafmedia.com/
 ****************************************************************************/
package;

import com.github.haxePixiGAF.display.GAFMovieClip;
import haxe.Timer;

class SlotBar
{
	private var _bar:GAFMovieClip;
	private var _slots:Array<GAFMovieClip>;
	private var _spinResult:Array<Int>;
	private var _machineType:String;

	private var _sequence:SequencePlaybackInfo;
	private var _timer:Timer;

	public function SlotBar(slotBarMC:GAFMovieClip)
	{
		if(!slotBarMC)throw new ArgumentError("Error:slotBarMC cannot be null");

		_bar=slotBarMC;
		_slots=new Array<GAFMovieClip>(3, true);
		_timer=new Timer(0, 1);
		_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);

		var name:String;
		var l:Int=_slots.length;
		for(i in 0...l)
		{
			name="fruit" +(i + 1);
			//_slots[i]=_bar.getChildByName(name)as GAFMovieClip;
			_slots[i]=_bar[name];

			if(!_slots[i])
				throw new Dynamic("Cannot find slot movie.");
		}
	}

	public function playSequenceWithTimeout(sequence:SequencePlaybackInfo, timeout:Float):Void
	{
		_sequence=sequence;
		_timer.reset();
		_timer.delay=timeout;
		_timer.start();
	}

	private function onTimerComplete(event:Dynamic/*TimerEvent*/):Void
	{
		_bar.loop=_sequence.looped;
		_bar.setSequence(_sequence.name);

		if(_sequence.name=="stop")
		{
			showSpinResult();
		}
	}

	public function randomizeSlots(maxTypes:Int, machineType:String):Void
	{
		var l:Int=_slots.length;
		var slotImagePos:Int;
		var seqName:String;
		for(i in 0...l)
		{
			slotImagePos=Math.floor(Math.random()* maxTypes)+ 1;
			seqName=slotImagePos + "_" + machineType;
			_slots[i].setSequence(seqName, false);
		}
	}

	public function setSpinResult(fruits:Array<Int>, machineType:String):Void
	{
		_spinResult=fruits;
		_machineType=machineType;
	}

	public function showSpinResult():Void
	{
		var l:Int=_slots.length;
		var seqName:String;
		for(i in 0...l)
		{
			seqName=(_spinResult[i])+ "_" + _machineType;
			_slots[i].setSequence(seqName, false);
		}
	}

	public function switchSlotType(maxSlots:Int):Void
	{
		var l:Int=_slots.length;
		var curFrame:Int;
		var maxFrame:Int;
		for(i in 0...l)
		{
			curFrame=_slots[i].currentFrame - 1;
			maxFrame=_slots[i].totalFrames;
			curFrame +=maxSlots;
			if(curFrame>=maxFrame)
			{
				curFrame=curFrame % maxSlots;
			}

			_slots[i].gotoAndStop(curFrame + 1);
		}
	}

	public function getBar():GAFMovieClip
	{
		return _bar;
	}
}