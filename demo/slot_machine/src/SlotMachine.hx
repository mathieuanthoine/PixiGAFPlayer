/**
 * Created by Nazar on 27.11.2014.
 */
package;
import com.github.haxePixiGAF.data.GAFTimeline;
import com.github.haxePixiGAF.display.GAFMovieClip;
import haxe.Timer;

class SlotMachine extends GAFMovieClip
{
	public static inline var MACHINE_STATE_INITIAL:Int=0;
	public static inline var MACHINE_STATE_ARM_TOUCHED:Int=1;
	public static inline var MACHINE_STATE_SPIN:Int=2;
	public static inline var MACHINE_STATE_SPIN_END:Int=3;
	public static inline var MACHINE_STATE_WIN:Int=4;
	public static inline var MACHINE_STATE_END:Int=5;
	public static inline var MACHINE_STATE_COUNT:Int=6;

	public static inline var PRIZE_NONE:Int=0;
	public static inline var PRIZE_C1K:Int=1;
	public static inline var PRIZE_C500K:Int=2;
	public static inline var PRIZE_C1000K:Int=3;
	public static inline var PRIZE_COUNT:Int=4;

	private static inline var REWARD_COINS:String="coins";
	private static inline var REWARD_CHIPS:String="chips";
	private static inline var FRUIT_COUNT:Int=5;
	private static inline var BAR_TIMEOUT:Float=0.2;

	private var _arm:GAFMovieClip;
	private var _switchMachineBtn:GAFMovieClip;
	private var _whiteBG:GAFMovieClip;
	private var _rewardText:GAFMovieClip;
	private var _bottomCoins:GAFMovieClip;
	private var _centralCoins:Array<GAFMovieClip>;
	private var _winFrame:GAFMovieClip;
	private var _spinningRays:GAFMovieClip;
	private var _bars:Array<SlotBar>;

	private var _state:Int;
	private var _rewardType:String;

	//private var _prizeSequence:Array<Int>;
	private var _prize:Int;

	private var _timer:Timer;

	public function new(gafTimeline:GAFTimeline)
	{
		super(gafTimeline);
		play(true);

		_state=MACHINE_STATE_INITIAL;
		_rewardType=REWARD_CHIPS;

		//_prizeSequence=new<Int>[PRIZE_C1000K, PRIZE_NONE, PRIZE_C1000K, PRIZE_C1K, PRIZE_C1000K, PRIZE_C500K];
		_prize=0;

		_centralCoins = [];// new Array<GAFMovieClip>(3);
		_bars = [];// new Array<SlotBar>(3);

		//_timer = new Timer(0, 1);
		//_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);

		// Here we get pointers to inner Gaf objects for quick access
		// We use flash object instance name
		//_arm=obj.arm;
		//_switchMachineBtn=obj.swapBtn;
		//_switchMachineBtn.stop();
		//_switchMachineBtn.touchGroup=true;
		//_whiteBG=obj.white_exit;
		//_bottomCoins=obj.wincoins;
		//_rewardText=obj.wintext;
		//_winFrame=obj.frame;
		//_spinningRays=obj.spinning_rays;

		// Sequence "start" will play once and callback SlotMachine::onFinishRaysSequence
		// will be called when last frame of "start" sequence shown
		//_spinningRays.setSequence("start");
		//_spinningRays.addEventListener(GAFMovieClip.EVENT_TYPE_SEQUENCE_END, onFinishRaysSequence);

		var i:Int;
		var l:Int=obj.numChildren;
		for(i in 0...l)
		{
			var child:DisplayObject=obj.getChildAt(i);
			if(child !=_arm && child !=_switchMachineBtn)
			{
				child.touchable=false;
			}
		}

		l=_centralCoins.length;
		for(i in 0...l)
		{
			var prize:Int=i + 1;
			_centralCoins[i]=obj[getTextByPrize(prize)];
		}

		l=_bars.length;
		var barName:String;
		for(i in 0...l)
		{
			barName="slot" +(i + 1);

			_bars[i]=new SlotBar(obj[barName]);
			_bars[i].randomizeSlots(FRUIT_COUNT, _rewardType);
		}

		defaultPlacing();
	}

	public function getArm():GAFMovieClip
	{
		return _arm;
	}

	public function getSwitchMachineBtn():GAFMovieClip
	{
		return _switchMachineBtn;
	}

	public function start():Void
	{
		if(_state==MACHINE_STATE_INITIAL)
		{
			nextState();
		}
	}

	// General callback for sequences
	// Used by Finite-state machine
	// see setAnimationStartedNextLoopDelegate and setAnimationFinishedPlayDelegate
	// for looped and non-looped sequences
	private function onFinishSequence(event:Dynamic/*Event*/):Void
	{
		nextState();
	}

	private function onTimerComplete(event:Dynamic/*TimerEvent*/):Void
	{
		nextState();
	}

	private function onFinishRaysSequence(event:Dynamic/*Event*/):Void
	{
		_spinningRays.removeEventListener(GAFMovieClip.EVENT_TYPE_SEQUENCE_END, onFinishRaysSequence);
		_spinningRays.setSequence("spin", true);
	}

	public function switchType():Void
	{
		if(_rewardType==REWARD_CHIPS)
		{
			_rewardType=REWARD_COINS;
		}
		else if(_rewardType==REWARD_COINS)
		{
			_rewardType=REWARD_CHIPS;
		}

		var state:Int=_state - 1;
		if(state<0)
		{
			state=MACHINE_STATE_COUNT - 1;
		}
		_state=state;
		nextState();

		var l:Int=_bars.length;
		for(i in 0...l)
		{
			_bars[i].switchSlotType(FRUIT_COUNT);
		}
	}

	private function defaultPlacing():Void
	{
		// Here we set default sequences if needed
		// Sequence names are used from flash labels
		_whiteBG.gotoAndStop("whiteenter");
		_winFrame.setSequence("stop");
		_arm.setSequence("stop");
		_bottomCoins.visible=false;
		_bottomCoins.loop=false;
		_rewardText.setSequence("notwin", true);

		var i:Int;
		var l:Int=_centralCoins.length;
		for(i in 0...l)
		{
			_centralCoins[i].visible=false;
		}
		l=_bars.length;
		for(i in 0...l)
		{
			_bars[i].getBar().setSequence("statics");
		}
	}

	/* This method describes Finite-state machine
	 * state switches in 2 cases:
	 * 1)specific sequence ended playing and callback called
	 * 2)by timer
	 */
	private function nextState():Void
	{
		++_state;
		if(_state==MACHINE_STATE_COUNT)
		{
			_state=MACHINE_STATE_INITIAL;
		}
		resetCallbacks();

		var i:Int;
		var l:Int;
		var sequence:SequencePlaybackInfo;
		switch(_state)
		{
			case MACHINE_STATE_INITIAL:
				defaultPlacing();
				break;

			case MACHINE_STATE_ARM_TOUCHED:
				_arm.setSequence("push");
				_arm.addEventListener(GAFMovieClip.EVENT_TYPE_SEQUENCE_END, onFinishSequence);
				break;

			case MACHINE_STATE_SPIN:
				_arm.setSequence("stop");
				_timer.reset();
				_timer.delay=3000;
				_timer.start();
				l=_bars.length;
				var seqName:String;
				for(i in 0...l)
				{
					seqName="rotation_" + _rewardType;
					sequence=new SequencePlaybackInfo(seqName, true);
					_bars[i].playSequenceWithTimeout(sequence, BAR_TIMEOUT * i * 1000);
				}
				break;

			case MACHINE_STATE_SPIN_END:
				_timer.reset();
				_timer.delay=BAR_TIMEOUT * 4 * 1000;
				_timer.start();
				/*_prize=*/
				generatePrize();
				var spinResult:Array<Int>=generateSpinResult(_prize);
				l=_bars.length;
				for(i in 0...l)
				{
					_bars[i].setSpinResult(spinResult[i], _rewardType);
					sequence=new SequencePlaybackInfo("stop", false);
					_bars[i].playSequenceWithTimeout(sequence, BAR_TIMEOUT * i * 1000);
				}
				break;

			case MACHINE_STATE_WIN:
				showPrize(_prize);
				break;

			case MACHINE_STATE_END:
				_whiteBG.play();
				_whiteBG.addEventListener(GAFMovieClip.EVENT_TYPE_SEQUENCE_END, onFinishSequence);
				break;

			default:
				break;
		}
	}

	private function resetCallbacks():Void
	{
		_whiteBG.removeEventListener(GAFMovieClip.EVENT_TYPE_SEQUENCE_END, onFinishSequence);
		_arm.removeEventListener(GAFMovieClip.EVENT_TYPE_SEQUENCE_END, onFinishSequence);
	}

	private function generatePrize():Int
	{
		++_prize;
		if(_prize==PRIZE_COUNT)
		{
			_prize=0;
		}

		return _prize;
	}

	/* Method returns machine spin result
	 *		4 3 1
	 *		2 2 2
	 *		1 1 5
	 * where numbers are fruit indexes
	 */
	private function generateSpinResult(prize:Int):Array<Int>
	{
		var l:Int=3;
		var result:Array<Int>=new Array<Int>(l, true);
		var i:Int;
		for(i in 0...l)
		{
			result[i]=new Array<Int>(l);
			result[i][0]=Math.floor(Math.random()* FRUIT_COUNT)+ 1;
			result[i][2]=Math.floor(Math.random()* FRUIT_COUNT)+ 1;
		}

		var centralFruit:Int;
		switch(prize)
		{
			case PRIZE_NONE:
				centralFruit=Math.floor(Math.random()* FRUIT_COUNT)+ 1;
				break;
			case PRIZE_C1K:
				centralFruit=Math.floor(Math.random()*(FRUIT_COUNT / 2))+ 1;
				break;
			case PRIZE_C500K:
				centralFruit=Math.floor(Math.random()*(FRUIT_COUNT / 2))+ FRUIT_COUNT / 2 + 1;
				break;
			case PRIZE_C1000K:
				centralFruit=FRUIT_COUNT - 1;
				break;
			default:
				break;
		}

		if(prize==PRIZE_NONE)
		{
			result[0][1]=centralFruit;
			result[1][1]=centralFruit;
			result[2][1]=centralFruit;
			while(result[2][1]==result[1][1])
			{
				result[2][1]=Math.floor(Math.random()* FRUIT_COUNT)+ 1;// last fruit should be another
			}
		}
		else
		{
			for(i in 0...l)
			{
				result[i][1]=centralFruit;
			}
		}

		return result;
	}

	// Here we switching to win animation
	private function showPrize(prize:Int):Void
	{
		var coinsBottomState:String=getTextByPrize(prize)+ "_" + _rewardType;
		_bottomCoins.visible=true;
		_bottomCoins.gotoAndStop(coinsBottomState);

		if(prize==PRIZE_NONE)
		{
			nextState();
			return;
		}

		_winFrame.setSequence("win", true);
		_rewardText.setSequence(getTextByPrize(prize));

		var idx:Int=prize - 1;
		_centralCoins[idx].visible=true;
		_centralCoins[idx].play(true);
		_centralCoins[idx].setSequence(_rewardType);

		_timer.reset();
		_timer.delay=2000;
		_timer.start();

	}

	private function getTextByPrize(prize:Int):String
	{
		switch(prize)
		{
			case PRIZE_NONE:
				return "notwin";

			case PRIZE_C1K:
				return "win1k";

			case PRIZE_C500K:
				return "win500k";

			case PRIZE_C1000K:
				return "win1000k";

			default:
				return "";
		}
	}
}