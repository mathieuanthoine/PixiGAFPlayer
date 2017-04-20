package com.github.haxePixiGAF.display;

import com.github.haxePixiGAF.data.GAF;
import com.github.haxePixiGAF.data.GAFAsset;
import com.github.haxePixiGAF.data.GAFTimeline;
import com.github.haxePixiGAF.data.GAFTimelineConfig;
import com.github.haxePixiGAF.data.config.CAnimationFrame;
import com.github.haxePixiGAF.data.config.CAnimationFrameInstance;
import com.github.haxePixiGAF.data.config.CAnimationObject;
import com.github.haxePixiGAF.data.config.CAnimationSequence;
import com.github.haxePixiGAF.data.config.CFilter;
import com.github.haxePixiGAF.data.config.CFrameAction;
import com.github.haxePixiGAF.data.config.CTextureAtlas;
import com.github.haxePixiGAF.events.GAFEvent;
import com.github.haxePixiGAF.utils.DebugUtility;
import com.github.mathieuanthoine.gaf.Main;
import js.Lib;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject;
import pixi.core.math.Matrix;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import haxe.extern.EitherType;

using com.github.haxePixiGAF.utils.MatrixUtility;
using com.github.haxePixiGAF.utils.EventEmitterUtility;

/**
 * GAFMovieClip represents animation display object that is ready to be used in Starling display list. It has
 * all controls for animation familiar from standard MovieClip(<code>play</code>,<code>stop</code>,<code>gotoAndPlay,</code>etc.)
 * and some more like<code>loop</code>,<code>nPlay</code>,<code>setSequence</code>that helps manage playback
 */
/**
 * TODO
 * @author Mathieu Anthoine
 */
class GAFMovieClip extends Container implements IAnimatable implements IGAFDisplayObject implements IMaxSize
{
	/** Dispatched when playhead reached first frame of sequence */
	public static inline var EVENT_TYPE_SEQUENCE_START:String = "typeSequenceStart";
	
	/** Dispatched when playhead reached end frame of sequence */
	public static inline var EVENT_TYPE_SEQUENCE_END:String = "typeSequenceEnd";
	
	/** Dispatched whenever the movie has displayed its last frame. */
	// GAFEvent.COMPLETE

	private static var HELPER_MATRIX:Matrix=new Matrix();
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

	//TODO TextureSmoothing.BILINEAR
	private var _smoothing:String = "";// TextureSmoothing.BILINEAR;

	private var _displayObjectsDictionary:Map<String,IGAFDisplayObject>;
	private var _stencilMasksDictionary:Map<String,DisplayObject>;
	private var _displayObjectsVector:Array<IGAFDisplayObject>;
	private var _imagesVector:Array<IGAFImage>;
	private var _mcVector:Array<GAFMovieClip>;

	private var _playingSequence:CAnimationSequence;
	private var _timelineBounds:Rectangle;
	private var _maxSize:Point;
	//TODO _boundsAndPivot
	//private var _boundsAndPivot:MeshBatch;
	private var _config:GAFTimelineConfig;
	private var _gafTimeline:GAFTimeline;

	private var _loop:Bool=true;
	private var _skipFrames:Bool=true;
	private var _reset:Bool=false;
	private var _masked:Bool=false;
	private var _inPlay:Bool=false;
	private var _hidden:Bool=false;
	private var _reverse:Bool=false;
	private var _started:Bool=false;
	private var _disposed:Bool=false;
	private var _hasFilter:Bool=false;
	private var _useClipping:Bool=false;
	private var _alphaLessMax:Bool=false;
	private var _addToJuggler:Bool=false;

	private var _scale:Float;
	private var _contentScaleFactor:Float;
	private var _currentTime:Float=0;
	// Hold the current time spent animating
	private var _lastFrameTime:Float=0;
	private var _frameDuration:Float;

	private var _nextFrame:Int;
	private var _startFrame:Int;
	private var _finalFrame:Int;
	private var _currentFrame:Int;
	private var _totalFrames:Int;

	//TODO _filterChain
	//private var _filterChain:GAFFilterChain;
	private var _filterConfig:CFilter;
	private var _filterScale:Float;

	//private var _pivotChanged:Bool=false;

	private var __debugOriginalAlpha:Float=null;

	//private var _orientationChanged:Bool=false;

	//TODO GAFStencilMaskStyle
	//private var _stencilMaskStyle:GAFStencilMaskStyle;

	// --------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------

	/**
	 * Creates a new GAFMovieClip instance.
	 *
	 * @param gafTimeline<code>GAFTimeline</code>from what<code>GAFMovieClip</code>will be created
	 * @param fps defines the frame rate of the movie clip. If not set - the stage config frame rate will be used instead.
	 * @param addToJuggler if<code>true - GAFMovieClip</code>will be added to<code>Starling.juggler</code>
	 * and removed automatically on<code>dispose</code>
	 */
	public function new(gafTimeline:GAFTimeline, pFps:Int=-1, addToJuggler:Bool=true)
	{
		super();
		
		_gafTimeline=gafTimeline;
		_config=gafTimeline.config;
		_scale=gafTimeline.scale;
		_contentScaleFactor=gafTimeline.contentScaleFactor;
		_addToJuggler=addToJuggler;

		initialize(gafTimeline.textureAtlas, gafTimeline.gafAsset);

		if(_config.bounds!=null)
		{
			_timelineBounds=_config.bounds.clone();
		}
		if(pFps>0)
		{
			fps=pFps;
		}

		draw();
	}

	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------

	/** 
	 * Returns the child display object that exists with the specified ID. Use to obtain animation's parts
	 *
	 * @param id Child ID
	 * @return The child display object with the specified ID
	 */
	public function getChildByID(id:String):IGAFDisplayObject
	{
		return _displayObjectsDictionary[id];
	}

	/** 
	 * Returns the mask display object that exists with the specified ID. Use to obtain animation's masks
	 *
	 * @param id Mask ID
	 * @return The mask display object with the specified ID
	 */
	public function getMaskByID(id:String):DisplayObject
	{
		return _stencilMasksDictionary[id];
	}

	/**
	 * Shows mask display object that exists with the specified ID. Used for debug purposes only!
	 *
	 * @param id Mask ID
	 */
	public function showMaskByID(id:String):Void
	{
		var maskObject:IGAFDisplayObject=_displayObjectsDictionary[id];
		var maskAsDisplayObject:DisplayObject=cast(maskObject, DisplayObject);
		var stencilMaskObject:DisplayObject=_stencilMasksDictionary[id];
		if(maskObject!=null && stencilMaskObject!=null)
		{
			maskAsDisplayObject.mask=stencilMaskObject;
			addChild(stencilMaskObject);
			addChild(maskAsDisplayObject);
		}
		else
		{
			trace("WARNING:mask object is missing. It might be disposed.");
		}
	}

	/**
	 * Hides mask display object that previously has been shown using<code>showMaskByID</code>method.
	 * Used for debug purposes only!
	 *
	 * @param id Mask ID
	 */
	public function hideMaskByID(id:String):Void
	{
		var maskObject:IGAFDisplayObject=_displayObjectsDictionary[id];
		var maskAsDisplayObject:DisplayObject=cast(maskObject, DisplayObject);
		var stencilMaskObject:DisplayObject=_stencilMasksDictionary[id];
		if(stencilMaskObject!=null)
		{
			if(stencilMaskObject.parent==this)
			{
				stencilMaskObject.parent.mask=null;
				removeChild(stencilMaskObject);
				removeChild(maskAsDisplayObject);
			}
		}
		else
		{
			trace("WARNING:mask object is missing. It might be disposed.");
		}
	}

	/**
	 * Clear playing sequence. If animation already in play just continue playing without sequence limitation
	 */
	public function clearSequence():Void
	{
		_playingSequence=null;
	}

	/**
	 * Returns id of the sequence where animation is right now. If there is no sequences - returns<code>null</code>.
	 *
	 * @return id of the sequence
	 */
	public var currentSequence(get_currentSequence, null):String;
 	private function get_currentSequence():String
	{
		var sequence:CAnimationSequence=_config.animationSequences.getSequenceByFrame(currentFrame);
		if(sequence!=null)
		{
			return sequence.id;
		}
		return null;
	}

	/**
	 * Set sequence to play
	 *
	 * @param id Sequence ID
	 * @param play Play or not immediately.<code>true</code>- starts playing from sequence start frame.<code>false</code>- go to sequence start frame and stop
	 * @return sequence to play
	 */
	public function setSequence(id:String, play:Bool=true):CAnimationSequence
	{
		_playingSequence=_config.animationSequences.getSequenceByID(id);

		if(_playingSequence!=null)
		{
			var startFrame:Int=_reverse ? _playingSequence.endFrameNo - 1:_playingSequence.startFrameNo;
			if(play)
			{
				gotoAndPlay(startFrame);
			}
			else
			{
				gotoAndStop(startFrame);
			}
		}

		return _playingSequence;
	}

	/**
	 * Moves the playhead in the timeline of the movie clip<code>play()</code>or<code>play(false)</code>.
	 * Or moves the playhead in the timeline of the movie clip and all child movie clips<code>play(true)</code>.
	 * Use<code>play(true)</code>in case when animation contain nested timelines for correct playback right after
	 * initialization(like you see in the original swf file).
	 * @param applyToAllChildren Specifies whether playhead should be moved in the timeline of the movie clip
	 *(<code>false</code>)or also in the timelines of all child movie clips(<code>true</code>).
	 */
	public function play(applyToAllChildren:Bool=false):Void
	{
		
		_started=true;

		if(applyToAllChildren)
		{
			var i:Int=_mcVector.length;
			while(i-->0)
			{
				_mcVector[i]._started=true;
			}
		}

		_play(applyToAllChildren, true);
	}

	/**
	 * Stops the playhead in the movie clip<code>stop()</code>or<code>stop(false)</code>.
	 * Or stops the playhead in the movie clip and in all child movie clips<code>stop(true)</code>.
	 * Use<code>stop(true)</code>in case when animation contain nested timelines for full stop the
	 * playhead in the movie clip and in all child movie clips.
	 * @param applyToAllChildren Specifies whether playhead should be stopped in the timeline of the
	 * movie clip(<code>false</code>)or also in the timelines of all child movie clips(<code>true</code>)
	 */
	public function stop(applyToAllChildren:Bool=false):Void
	{
		
		_started=false;

		if(applyToAllChildren)
		{
			var i:Int=_mcVector.length;
			while(i-->0)
			{
				_mcVector[i]._started=false;
			}
		}

		_stop(applyToAllChildren, true);
	}

	/**
	 * Brings the playhead to the specified frame of the movie clip and stops it there. First frame is "1"
	 *
	 * @param frame A number representing the frame number, or a string representing the label of the frame, to which the playhead is sent.
	 */
	public function gotoAndStop(frame:Dynamic):Void
	{
		checkAndSetCurrentFrame(frame);

		stop();
	}

	/**
	 * Starts playing animation at the specified frame. First frame is "1"
	 *
	 * @param frame A number representing the frame number, or a string representing the label of the frame, to which the playhead is sent.
	 */
	public function gotoAndPlay(frame:Dynamic):Void
	{
		checkAndSetCurrentFrame(frame);

		play();
	}

	/**
	 * Set the<code>loop</code>value to the GAFMovieClip instance and for the all children.
	 */
	public function loopAll(loop:Bool):Void
	{
		//TODO: loop
		//loop=loop;

		var i:Int=_mcVector.length;
		while(i-->0)
		{
			_mcVector[i].loop=loop;
		}
	}

	/** 
	 * Advances all objects by a certain time(in seconds).
	 * @see starling.animation.IAnimatable
	 */
	public function advanceTime(passedTime:Float):Void
	{

		if(_disposed)
		{
			trace("WARNING:GAFMovieClip is disposed but is not removed from the Juggler");
			return;
		}
		else if(_config.disposed)
		{
			destroy();
			return;
		}

		if(_inPlay && _frameDuration !=Math.POSITIVE_INFINITY)
		{
			_currentTime +=passedTime;

			var framesToPlay:Int=Std.int((_currentTime - _lastFrameTime)/ _frameDuration);
			if(_skipFrames)
			{
				//here we skip the drawing of all frames to be played right now, but the last one
				for(i in 0...framesToPlay)
				{
					if(_inPlay)
					{
						changeCurrentFrame((i + 1)!=framesToPlay);
					}
					else //if a playback was Interrupted by some action or an event
					{
						if(!_disposed)
						{
							draw();
						}
						break;
					}
				}
			}
			else if(framesToPlay>0)
			{
				changeCurrentFrame(false);
			}
		}
		if(_mcVector!=null)
		{
			for(i in 0..._mcVector.length)
			{
				_mcVector[i].advanceTime(passedTime);
			}
		}
	}

	/** Shows bounds of a whole animation with a pivot point.
	 * Used for debug purposes.
	 */
	public function showBounds(value:Bool):Void
	{
		if(_config.bounds!=null)
		{
			//TODO showBounds
			trace ("TODO showBounds");
			
			//if(!_boundsAndPivot)
			//{
				//_boundsAndPivot=new MeshBatch();
				//updateBounds(_config.bounds);
			//}
//
			//if(value)
			//{
				//addChild(_boundsAndPivot);
			//}
			//else
			//{
				//removeChild(_boundsAndPivot);
			//}
		}
	}

	/**  */
	public function setFilterConfig(value:CFilter, scale:Float=1):Void
	{
		//TODO: setFilterConfig
		trace ("TODO: setFilterConfig");
		
		//if(!Starling.current.contextValid)
		//{
			//return;
		//}
//
		//if(_filterConfig !=value || _filterScale !=scale)
		//{
			//if(value)
			//{
				//_filterConfig=value;
				//_filterScale=scale;
//
				//if(_filterChain)
				//{
					//_filterChain.dispose();
				//}
				//else
				//{
					//_filterChain=new GAFFilterChain();
				//}
//
				//_filterChain.setFilterData(_filterConfig);
//
				//filter=_filterChain;
			//}
			//else
			//{
				//if(filter)
				//{
					//filter.dispose();
					//filter=null;
				//}
//
				//_filterChain=null;
				//_filterConfig=null;
				//_filterScale=NaN;
			//}
		//}
	}

	public function invalidateOrientation():Void
	{
		//_orientationChanged=true;
	}

	/**
	 * Creates a new instance of GAFMovieClip.
	 */
	public function copy():GAFMovieClip
	{
		return new GAFMovieClip(_gafTimeline, Std.int(fps), _addToJuggler);
	}

	//--------------------------------------------------------------------------
	//
	//  PRIVATE METHODS
	//
	// --------------------------------------------------------------------------

	private function _gotoAndStop(frame:Dynamic):Void
	{
		checkAndSetCurrentFrame(frame);

		_stop();
	}

	private function _play(applyToAllChildren:Bool=false, calledByUser:Bool=false):Void
	{
		if(_inPlay && !applyToAllChildren)
		{
			return;
		}

		var i:Int, l:Int;

		if(_totalFrames>1)
		{
			_inPlay=true;
		}

		if(applyToAllChildren && _config.animationConfigFrames.frames.length>0)
		{
			var frameConfig:CAnimationFrame=_config.animationConfigFrames.frames[_currentFrame];
			if(frameConfig.actions!=null)
			{
				var action:CFrameAction;
				var l:UInt = frameConfig.actions.length;
				for(i in 0...l)
				{
					action=frameConfig.actions[i];
					if(action.type==CFrameAction.STOP
							||(action.type==CFrameAction.GOTO_AND_STOP
							&& Std.parseInt(action.params[0])==currentFrame))
					{
						_inPlay=false;
						return;
					}
				}
			}

			var child:Container;
			var childMC:GAFMovieClip;
			l = children.length;
			for(i in 0...l)
			{
				child=cast(getChildAt(i),Container);
				if(Std.is(child, GAFMovieClip))
				{
					childMC=cast(child, GAFMovieClip);
					if(calledByUser)
					{
						childMC.play(true);
					}
					else
					{
						childMC._play(true);
					}
				}
			}
		}

		runActions();

		_reset=false;
	}

	private function _stop(applyToAllChildren:Bool=false, calledByUser:Bool=false):Void
	{
		_inPlay=false;

		if(applyToAllChildren
		&& _config.animationConfigFrames.frames.length>0)
		{
			var child:Container;
			var childMC:GAFMovieClip;
			for(i in 0...children.length)
			{
				child = cast (getChildAt(i), Container);
				if(Std.is(child, GAFMovieClip))
				{
					childMC=cast(child, GAFMovieClip);
					if(calledByUser)
					{
						childMC.stop(true);
					}
					else
					{
						childMC._stop(true);
					}
				}
			}
		}
	}

	private function checkPlaybackEvents():Void
	{
		var sequence:CAnimationSequence;
		if(hasEventListener(EVENT_TYPE_SEQUENCE_START))
		{
			sequence=_config.animationSequences.getSequenceStart(_currentFrame + 1);
			if(sequence!=null)
			{
				emit(EVENT_TYPE_SEQUENCE_START,{target:this,bubbles:false,data:sequence});
			}
		}
		if(hasEventListener(EVENT_TYPE_SEQUENCE_END))
		{
			sequence=_config.animationSequences.getSequenceEnd(_currentFrame + 1);
			if(sequence!=null)
			{
				emit(EVENT_TYPE_SEQUENCE_END,{target:this,bubbles:false,data:sequence});
			}
		}
		if(hasEventListener(GAFEvent.COMPLETE))
		{
			if(_currentFrame==_finalFrame)
			{
				emit(GAFEvent.COMPLETE);
			}
		}
		
	}

	private function runActions():Void
	{
		if(_config.animationConfigFrames.frames.length==0)
		{
			return;
		}

		var i:Int, l:Int;
		var actions:Array<CFrameAction> = _config.animationConfigFrames.frames[_currentFrame].actions;
		if(actions!=null)
		{
			var action:CFrameAction;
			var l:UInt = actions.length;
			for(i in 0...l)
			{
				action=actions[i];
				switch(action.type)
				{
					case CFrameAction.STOP:
						stop();
					case CFrameAction.PLAY:
						play();
					case CFrameAction.GOTO_AND_STOP:
						gotoAndStop(action.params[0]);
					case CFrameAction.GOTO_AND_PLAY:
						gotoAndPlay(action.params[0]);
					case CFrameAction.DISPATCH_EVENT:
						//TODO CFrameAction.DISPATCH_EVENT
						trace ("CFrameAction.DISPATCH_EVENT");
						var actionType:String=action.params[0];
						if(hasEventListener(actionType))
						{
							var bubbles:Bool = false;
							var data:Dynamic=null;
							
							switch(action.params.length)
							{
								case 4:
									data=action.params[3];
								case 3:
									// cancelable param is not used
									bubbles=cast(action.params[1],Bool);
								case 2:
									bubbles=cast(action.params[1],Bool);
							}
							emit(actionType, {target:this,bubbles:bubbles, data:data});
						}
						//if(actionType==CSound.GAF_PLAY_SOUND && GAF.autoPlaySounds)
						//{
							//_gafTimeline.startSound(currentFrame);
						//}
				}
			}
		}
	}

	private function checkAndSetCurrentFrame(frame:Dynamic):Void
	{
		if (cast(frame,UInt) > 0)
		{
			if(frame>_totalFrames)
			{
				frame=_totalFrames;
			}
		}
		else if(Std.is(frame, String))
		{
			var label:String=frame;
			frame=_config.animationSequences.getStartFrameNo(label);

			if(frame==0)
			{
				throw "Frame label " + label + " not found";
			}
		}
		else
		{
			frame=1;
		}

		if(_playingSequence!=null && !_playingSequence.isSequenceFrame(frame))
		{
			_playingSequence=null;
		}

		if(_currentFrame !=frame - 1)
		{
			_currentFrame=cast(frame,UInt) - 1;
			runActions();
			//actions may Interrupt playback and lead to content disposition
			if(!_disposed)
			{
				draw();
			}
		}
	}

	private function clearDisplayList():Void
	{
		removeChildren();
	}

	private function draw():Void
	{
		
		var i:Int;
		var l:Int;

		if(_config.debugRegions!=null)
		{
			// Non optimized way when there are debug regions
			clearDisplayList();
		}
		else
		{
			// Just hide the children to avoid dispatching a lot of events and alloc temporary arrays
			var l:UInt = _displayObjectsVector.length;
			for(i in 0...l)
			{
				_displayObjectsVector[i].alpha=0;
			}

			l = _mcVector.length;
			
			for(i in 0...l)
			{
				_mcVector[i]._hidden=true;
			}
		}

		var frames:Array<CAnimationFrame>=_config.animationConfigFrames.frames;
		if(frames.length>_currentFrame)
		{
			var mc:GAFMovieClip;
			var objectPivotMatrix:Matrix;
			var displayObject:IGAFDisplayObject;
			var instance:CAnimationFrameInstance;
			var stencilMaskObject:DisplayObject;

			var animationObjectsDictionary:Map<String,CAnimationObject>=_config.animationObjects.animationObjectsDictionary;
			var frameConfig:CAnimationFrame=frames[_currentFrame];
			var instances:Array<CAnimationFrameInstance>=frameConfig.instances;
			l=instances.length;
			i=0;
			while(i<l)
			{
				instance=instances[i++];

				displayObject=_displayObjectsDictionary[instance.id];
				if(displayObject!=null)
				{
					objectPivotMatrix=getTransformMatrix(displayObject, HELPER_MATRIX);
					if (Std.is(displayObject, GAFMovieClip)) mc = cast(displayObject, GAFMovieClip);
					else mc = null;
					
					if(mc!=null)
					{
						if(instance.alpha<0)
						{
							mc.reset();
						}
						else if(mc._reset && mc._started)
						{
							mc._play(true);
						}
						mc._hidden=false;
					}

					if(instance.alpha<=0)
					{
						continue;
					}

					displayObject.alpha=instance.alpha;

					//if display object is not a mask
					if(!animationObjectsDictionary[instance.id].mask)
					{
						
						
						//if display object is under mask
						if(instance.maskID!="")
						{
							//TODO Mask support
							trace ("TODO Mask support");
							
							renderDebug(mc, instance, true);

							stencilMaskObject=_stencilMasksDictionary[instance.maskID];

							//if(stencilMaskObject)
							//{
								//_stencilMaskStyle=new GAFStencilMaskStyle();
								//cast(stencilMaskObject,GAFImage).style=_stencilMaskStyle;
//
								//instance.applyTransformMatrix(displayObject.transformationMatrix, objectPivotMatrix, _scale);
								//displayObject.invalidateOrientation();
//
								//cast(displayObjec,DisplayObject).mask=stencilMaskObject;
//
								//addChild(stencilMaskObject);
								//addChild(cast(displayObject,DisplayObject));
//
								//_stencilMaskStyle.threshold=1;
							//}
						}
						else //if display object is not masked
						{
							renderDebug(mc, instance, _masked);
							instance.applyTransformMatrix(displayObject.transformationMatrix, objectPivotMatrix, _scale);
							displayObject.invalidateOrientation();														
							displayObject.setFilterConfig(instance.filter, _scale);
							addChild(cast(displayObject,DisplayObject));						
							
						}

						if(mc!=null && mc._started)
						{
							mc._play(true);
						}

						if(DebugUtility.RENDERING_DEBUG && Std.is(displayObject,IGAFDebug))
						{
							var colors:Array<Int>=DebugUtility.getRenderingDifficultyColor(instance, _alphaLessMax, _masked, _hasFilter);
							cast(displayObject,IGAFDebug).debugColors=colors;
						}
					}
					else
					{
						var maskObject:IGAFDisplayObject=_displayObjectsDictionary[instance.id];
						if(maskObject!=null)
						{
							var maskInstance:CAnimationFrameInstance=frameConfig.getInstanceByID(instance.id);
							if(maskInstance!=null)
							{
								getTransformMatrix(maskObject, HELPER_MATRIX);
								maskInstance.applyTransformMatrix(maskObject.transformationMatrix, HELPER_MATRIX, _scale);
								maskObject.invalidateOrientation();
							}
							else
							{
								throw "Unable to find mask with ID " + instance.id;
							}

							if (Std.is(maskObject, GAFMovieClip)) mc = cast(maskObject, GAFMovieClip);
							else mc = null;
							
							if(mc!=null && mc._started)
							{
								mc._play(true);
							}
						}
					}
				}
			}
		}

		if(_config.debugRegions!=null)
		{
			addDebugRegions();
		}

		checkPlaybackEvents();
	}

	private function renderDebug(mc:GAFMovieClip, instance:CAnimationFrameInstance, masked:Bool):Void
	{

		if(DebugUtility.RENDERING_DEBUG && mc!=null)
		{
			//TODO renderDebug
			trace ("TODO renderDebug");
			//var hasFilter:Bool=(instance.filter !=null)|| _hasFilter;
			////var alphaLessMax:Bool=instance.alpha<GAF.maxAlpha || _alphaLessMax;
			//var alphaLessMax:Bool=instance.alpha<GAF.maxAlpha || _alphaLessMax;
			//
			//var changed:Bool=false;
			//if(mc._alphaLessMax !=alphaLessMax)
			//{
				//mc._alphaLessMax=alphaLessMax;
				//changed=true;
			//}
			//if(mc._masked !=masked)
			//{
				//mc._masked=masked;
				//changed=true;
			//}
			//if(mc._hasFilter !=hasFilter)
			//{
				//mc._hasFilter=hasFilter;
				//changed=true;
			//}
			//if(changed)
			//{
				//mc.draw();
			//}
		}
	}

	private function addDebugRegions():Void
	{
		//TODO addDebugRegions
		trace ("TODO addDebugRegions");
		
		//var debugView:Quad;
		//for (debugRegion in _config.debugRegions)
		//{
			//switch(debugRegion.type)
			//{
				//case GAFDebugInformation.TYPE_POINT:
					//debugView=new Quad(4, 4, debugRegion.color);
					//debugView.x=debugRegion.point.x - 2;
					//debugView.y=debugRegion.point.y - 2;
					//debugView.alpha=debugRegion.alpha;
					//break;
				//case GAFDebugInformation.TYPE_RECT:
					//debugView=new Quad(debugRegion.rect.width, debugRegion.rect.height, debugRegion.color);
					//debugView.x=debugRegion.rect.x;
					//debugView.y=debugRegion.rect.y;
					//debugView.alpha=debugRegion.alpha;
					//break;
			//}
//
			//addChild(debugView);
		//}
	}

	private function reset():Void
	{
		_gotoAndStop((_reverse ? _finalFrame:_startFrame)+ 1);
		_reset=true;
		_currentTime=0;
		_lastFrameTime=0;

		var i:Int=_mcVector.length;
		while(i-->0)
		{
			_mcVector[i].reset();
		}
	}

	private function initialize(textureAtlas:CTextureAtlas, gafAsset:GAFAsset):Void
	{
		_displayObjectsDictionary=new Map<String,IGAFDisplayObject>();
		_stencilMasksDictionary=new Map<String,DisplayObject>();
		_displayObjectsVector=[];
		_imagesVector=[];
		_mcVector=[];

		_currentFrame=0;
		_totalFrames = _config.framesCount;
		fps=_config.stageConfig!=null ? _config.stageConfig.fps: 60;

		var animationObjectsDictionary:Map<String,CAnimationObject>=_config.animationObjects.animationObjectsDictionary;

		var displayObject:DisplayObject=null;
		for (animationObjectConfig in animationObjectsDictionary)
		{
			switch(animationObjectConfig.type)
			{
				case CAnimationObject.TYPE_TEXTURE:
					
					var texture:IGAFTexture=textureAtlas.getTexture(animationObjectConfig.regionID);
					if(Std.is(texture, GAFScale9Texture) && !animationObjectConfig.mask)// GAFScale9Image doesn't work as mask
					{
						//TODO initialize GAFScale9Texture
						trace ("TODO initialize GAFScale9Texture");
						//displayObject=new GAFScale9Image(cast(texture,GAFScale9Texture));
					}
					else
					{
						displayObject = new GAFImage(texture);
						cast(displayObject,GAFImage).textureSmoothing=_smoothing;
					}
				case CAnimationObject.TYPE_TEXTFIELD:
					//TODO initialize GAFTextField
					trace ("TODO initialize GAFTextField");
					//var tfObj:CTextFieldObject=_config.textFields.textFieldObjectsDictionary[animationObjectConfig.regionID];
					//displayObject=new GAFTextField(tfObj, _scale, _contentScaleFactor);
				case CAnimationObject.TYPE_TIMELINE:
					var timeline:GAFTimeline=gafAsset.getGAFTimelineByID(animationObjectConfig.regionID);
					displayObject=new GAFMovieClip(timeline, Std.int(fps), false);
			}

			if(animationObjectConfig.maxSize!=null && Std.is(displayObject,IMaxSize))
			{
				var maxSize:Point=new Point(
						animationObjectConfig.maxSize.x * _scale,
						animationObjectConfig.maxSize.y * _scale);
				cast(displayObject,IMaxSize).maxSize=maxSize;
			}

			addDisplayObject(animationObjectConfig.instanceID, displayObject);
			if(animationObjectConfig.mask)
			{
				addDisplayObject(animationObjectConfig.instanceID, displayObject, true);
			}

			if(_config.namedParts !=null)
			{
				var instanceName:String=_config.namedParts[animationObjectConfig.instanceID];
				if (instanceName != null && !Reflect.hasField(this,instanceName))
				{
					Reflect.setField(this, _config.namedParts[animationObjectConfig.instanceID], displayObject);
					displayObject.name=instanceName;
				}
			}
		}

		//if(_addToJuggler)
		//{
			//Starling.juggler.add(this);
		//}
	}

	private function addDisplayObject(id:String, displayObject:DisplayObject, asMask:Bool=false):Void
	{
		if(asMask)
		{
			_stencilMasksDictionary[id]=displayObject;
		}
		else
		{
			_displayObjectsDictionary[id]=cast(displayObject,IGAFDisplayObject);
			_displayObjectsVector[_displayObjectsVector.length]=cast(displayObject, IGAFDisplayObject);
			if(Std.is(displayObject, IGAFImage))
			{
				_imagesVector[_imagesVector.length]=cast(displayObject, IGAFImage);
			}
			else if(Std.is(displayObject, GAFMovieClip))
			{
				_mcVector[_mcVector.length]=cast(displayObject, GAFMovieClip);
			}
		}
	}

	private function updateBounds(bounds:Rectangle):Void
	{
		//TODO updateBounds
		trace ("TODO updateBounds");
		
		//_boundsAndPivot.clear();
		////bounds
		//if(bounds.width>0 &&  bounds.height>0)
		//{
			//var quad:Quad=new Quad(bounds.width * _scale, 2, 0xff0000);
			//quad.x=bounds.x * _scale;
			//quad.y=bounds.y * _scale;
			//_boundsAndPivot.addMesh(quad);
			//quad=new Quad(bounds.width * _scale, 2, 0xff0000);
			//quad.x=bounds.x * _scale;
			//quad.y=bounds.bottom * _scale - 2;
			//_boundsAndPivot.addMesh(quad);
			//quad=new Quad(2, bounds.height * _scale, 0xff0000);
			//quad.x=bounds.x * _scale;
			//quad.y=bounds.y * _scale;
			//_boundsAndPivot.addMesh(quad);
			//quad=new Quad(2, bounds.height * _scale, 0xff0000);
			//quad.x=bounds.right * _scale - 2;
			//quad.y=bounds.y * _scale;
			//_boundsAndPivot.addMesh(quad);
		//}
		////pivot point
		//quad=new Quad(5, 5, 0xff0000);
		//_boundsAndPivot.addMesh(quad);
	}


	public function __debugHighlight():Void
	{

		if(Math.isNaN(__debugOriginalAlpha))
		{
			__debugOriginalAlpha=alpha;
		}
		alpha=1;
	}

	public function __debugLowlight():Void
	{

		if(Math.isNaN(__debugOriginalAlpha))
		{
			__debugOriginalAlpha=alpha;
		}
		alpha=.05;
	}

	public function __debugResetLight():Void
	{

		if(!Math.isNaN(__debugOriginalAlpha))
		{
			alpha=__debugOriginalAlpha;
			__debugOriginalAlpha=null;
		}
	}

	private function updateTransformMatrix():Void
	{		
		//if(_orientationChanged)
		//{
			//transformationMatrix=transformationMatrix;
			//_orientationChanged=false;
		//}
	}

	//--------------------------------------------------------------------------
	//
	// OVERRIDDEN METHODS
	//
	//--------------------------------------------------------------------------

	/** Removes a child at a certain index. The index positions of any display objects above
	 *  the child are decreased by 1. If requested, the child will be disposed right away. */
	override public function removeChildAt(index:Int/*, dispose:Bool=false*/):DisplayObject
	{
		//TODO: removeChildAt
		trace ("TODO: removeChildAt");
		
		//if(dispose)
		//{
			//var key:String;
			//var instanceName:String;
			//var child:DisplayObject=getChildAt(index);
			//if(Std.is(child, IGAFDisplayObject))
			//{
				//var id:Int=_mcVector.indexOf(cast(child,GAFMovieClip));
				//if(id>=0)
				//{
					//_mcVector.splice(id, 1);
				//}
				//id=_imagesVector.indexOf(cast(child,IGAFImage));
				//if(id>=0)
				//{
					//_imagesVector.splice(id, 1);
				//}
				//id=_displayObjectsVector.indexOf(cast(child,IGAFDisplayObject));
				//if(id>=0)
				//{
					//_displayObjectsVector.splice(id, 1);
//
					//for(key in _displayObjectsDictionary.keys())
					//{
						//if(_displayObjectsDictionary[key]==child)
						//{
							//if(_config.namedParts !=null)
							//{
								//instanceName=_config.namedParts[key];
								//if(instanceName!=null && Reflect.hasField(this,instanceName))
								//{
									////delete this[instanceName];
									//Reflect.deleteField(this, instanceName);
								//}
							//}
//
							////delete _displayObjectsDictionary[key];
							//_displayObjectsDictionary[key] = null;
							//break;
						//}
					//}
				//}
//
				//for(key in _stencilMasksDictionary.keys())
				//{
					//if(_stencilMasksDictionary[key]==child)
					//{
						//if(_config.namedParts !=null)
						//{
							//instanceName=_config.namedParts[key];
							//if(instanceName!=null && Reflect.hasField(this,instanceName))
							//{
								////delete this[instanceName];
								//Reflect.deleteField(this, instanceName);
							//}
						//}
//
						////delete _stencilMasksDictionary[key];
						//_stencilMasksDictionary[key]=null;
						//break;
					//}
				//}
			//}
		//}

		//return super.removeChildAt(index, dispose);
		getChildAt(index).destroy();
		return super.removeChildAt(index);
	}

	/** Returns a child object with a certain name(non-recursively). */
	override public function getChildByName(name:String):DisplayObject
	{
		var numChildren:Int=_displayObjectsVector.length;
		for(i in 0...numChildren)
			if(_displayObjectsVector[i].name==name)
				return cast(_displayObjectsVector[i],DisplayObject);
		return super.getChildByName(name);
	}

	/**
	 * Disposes all resources of the display object instance. Note:this method won't delete used texture atlases from GPU memory.
	 * To delete texture atlases from GPU memory use<code>unloadFromVideoMemory()</code>method for<code>GAFTimeline</code>instance
	 * from what<code>GAFMovieClip</code>was instantiated.
	 * Call this method every time before delete no longer required instance! Otherwise GPU memory leak may occur!
	 */
	//override public function dispose():Void	
	override public function destroy(?options:EitherType<Bool, DestroyOptions>):Void
	{
		//TODO destroy
		
		if(_disposed)
		{
			return;
		}
		stop();

		//if(_addToJuggler)
		//{
			//Starling.juggler.remove(this);
		//}

		var l:Int=_displayObjectsVector.length;
		for(i in 0...l)
		{
			_displayObjectsVector[i].destroy();
		}

		//for(key in _stencilMasksDictionary)
		//{
			//_stencilMasksDictionary[key].dispose();
		//}
//
		//if(_boundsAndPivot)
		//{
			//_boundsAndPivot.dispose();
			//_boundsAndPivot=null;
		//}

		_displayObjectsDictionary=null;
		_stencilMasksDictionary=null;
		_displayObjectsVector=null;
		_imagesVector=null;
		_gafTimeline=null;
		_mcVector=null;
		_config=null;

		if(parent!=null)
		{
			//removeFromParent();
		}
		super.destroy(options);

		_disposed=true;
	}

	//public function render(painter/*:Painter*/):Void
	//{
		//try
		//{
			////super.render(painter);
		//}
		//catch(error:Dynamic)
		//{
			//throw error;
			////if(Std.is(error, IllegalOperationError)
					////&&(error.message as String).indexOf("not possible to stack filters")!=-1)
			////{
				////if(hasEventListener(ErrorEvent.ERROR))
				////{
					////dispatchEventWith(ErrorEvent.ERROR, true, error.message);
				////}
				////else
				////{
					////throw error;
				////}
			////}
			////else
			////{
				////throw error;
			////}
		//}
	//}

	/**  */
	//override public var pivotX(null, set_pivotX):Float;
 	//private function set_pivotX(value:Float):Void
	//{
		//_pivotChanged=true;
		//super.pivotX=value;
	//}

	/**  */
	//override public var pivotY(null, set_pivotY):Float;
 	//private function set_pivotY(value:Float):Void
	//{
		//_pivotChanged=true;
		//super.pivotY=value;
	//}

	
	//TODO: trouver un moyen elegant de manipuler tout ca (injection JS en dur ?)
	
	/**  */
	//override public function get x():Float
	//{
		//updateTransformMatrix();
		//return super.x;
	//}

	/**  */
	//override public function get y():Float
	//{
		//updateTransformMatrix();
		//return super.y;
	//}

	/**  */
	//override public var rotation(get_rotation, set_rotation):Float;
 	//private function get_rotation():Float
	//{
		//updateTransformMatrix();
		//return super.rotation;
	//}

	/**  */
	//override public var scaleX(get_scaleX, set_scaleX):Float;
 	//private function get_scaleX():Float
	//{
		//updateTransformMatrix();
		//return super.scaleX;
	//}

	/**  */
	//override public var scaleY(get_scaleY, set_scaleY):Float;
 	//private function get_scaleY():Float
	//{
		//updateTransformMatrix();
		//return super.scaleY;
	//}

	/**  */
	//override public var skewX(get_skewX, set_skewX):Float;
 	//private function get_skewX():Float
	//{
		//updateTransformMatrix();
		//return super.skewX;
	//}

	/**  */
	//override public var skewY(get_skewY, set_skewY):Float;
 	//private function get_skewY():Float
	//{
		//updateTransformMatrix();
		//return super.skewY;
	//}

	//--------------------------------------------------------------------------
	//
	//  EVENT HANDLERS
	//
	//--------------------------------------------------------------------------

	private function changeCurrentFrame(isSkipping:Bool):Void
	{
		_nextFrame=_currentFrame +(_reverse ? -1:1);
		_startFrame=(_playingSequence!=null ? _playingSequence.startFrameNo:1)- 1;
		_finalFrame=(_playingSequence!=null ? _playingSequence.endFrameNo:_totalFrames)- 1;

		if(_nextFrame>=_startFrame && _nextFrame<=_finalFrame)
		{
			_currentFrame=_nextFrame;
			_lastFrameTime +=_frameDuration;
		}
		else
		{
			if(!_loop)
			{
				stop();
			}
			else
			{
				_currentFrame=_reverse ? _finalFrame:_startFrame;
				_lastFrameTime +=_frameDuration;
				var resetInvisibleChildren:Bool=true;
			}
		}

		runActions();

		//actions may Interrupt playback and lead to content disposition
		if(_disposed)
		{
			return;
		}
		else if(_config.disposed)
		{
			destroy();
			return;
		}

		if(!isSkipping)
		{
			// Draw will trigger events if any
			draw();
		}
		else
		{
			checkPlaybackEvents();
		}

		//if(resetInvisibleChildren)
		//{
			////reset timelines that aren't visible
			//var i:Int=_mcVector.length;
			//while(i-->0)
			//{
				//if(_mcVector[i]._hidden)
				//{
					//_mcVector[i].reset();
				//}
			//}
		//}
	}

	//--------------------------------------------------------------------------
	//
	//  GETTERS AND SETTERS
	//
	//--------------------------------------------------------------------------

	/**
	 * Specifies the number of the frame in which the playhead is located in the timeline of the GAFMovieClip instance. First frame is "1"
	 */
	public var currentFrame(get_currentFrame, null):Int;
 	private function get_currentFrame():Int
	{
		return _currentFrame + 1;// Like in standart AS3 API for MovieClip first frame is "1" instead of "0"(but Internally used "0")
	}

	/**
	 * The total number of frames in the GAFMovieClip instance.
	 */
	public var totalFrames(get_totalFrames, null):Int;
 	private function get_totalFrames():Int
	{
		return _totalFrames;
	}

	/**
	 * Indicates whether GAFMovieClip instance already in play
	 */
	public var inPlay(get_inPlay, null):Bool;
 	private function get_inPlay():Bool
	{
		return _inPlay;
	}

	/**
	 * Indicates whether GAFMovieClip instance continue playing from start frame after playback reached animation end
	 */
	public var loop(get_loop, set_loop):Bool;
 	private function get_loop():Bool
	{
		return _loop;
	}

	private function set_loop(loop:Bool):Bool
	{
		return _loop=loop;
	}

	/**
	 * The smoothing filter that is used for the texture. Possible values are<code>TextureSmoothing.BILINEAR, TextureSmoothing.NONE, TextureSmoothing.TRILINEAR</code>
	 */
	private function set_smoothing(value:String):String
	{
		//if(TextureSmoothing.isValid(value))
		//{
			//_smoothing=value;
//
			//var i:Int=_imagesVector.length;
			//while(i-->0)
			//{
				//_imagesVector[i].textureSmoothing=_smoothing;
			//}
		//}
		
		return null;// _smoothing;
	}

	public var smoothing(get_smoothing, set_smoothing):String;
 	private function get_smoothing():String
	{
		return null;// _smoothing;
	}

	public var useClipping(get_useClipping, set_useClipping):Bool;
 	private function get_useClipping():Bool
	{
		return _useClipping;
	}

	/**  */
	public var maxSize(get_maxSize, set_maxSize):Point;
 	private function get_maxSize():Point
	{
		return _maxSize;
	}

	/**  */
	private function set_maxSize(value:Point):Point
	{
		return _maxSize=value;
	}

	/**
	 * if set<code>true</code>-<code>GAFMivieclip</code>will be clipped with flash stage dimensions
	 */
	private function set_useClipping(value:Bool):Bool
	{
		_useClipping=value;

		if(_useClipping && _config.stageConfig!=null)
		{
			//mask=new Quad(_config.stageConfig.width * _scale, _config.stageConfig.height * _scale);
		}
		else
		{
			mask=null;
		}
		
		return value;
	}

	public var fps(get_fps, set_fps):Float;
 	private function get_fps():Float
	{
		if(_frameDuration==Math.POSITIVE_INFINITY)
		{
			return 0;
		}
		return 1 / _frameDuration;
	}

	/**
	 * Sets an individual frame rate for<code>GAFMovieClip</code>. If this value is lower than stage fps -  the<code>GAFMovieClip</code>will skip frames.
	 */
	private function set_fps(value:Float):Float
	{
		if(value<=0)
		{
			_frameDuration=Math.POSITIVE_INFINITY;
		}
		else
		{
			_frameDuration=1 / value;
		}

		var i:Int=_mcVector.length;
		while(i-->0)
		{
			_mcVector[i].fps=value;
		}
		
		return value;
		
	}

	public var reverse(get_reverse, set_reverse):Bool;
 	private function get_reverse():Bool
	{
		return _reverse;
	}

	/**
	 * If<code>true</code>animation will be playing in reverse mode
	 */
	private function set_reverse(value:Bool):Bool
	{
		_reverse=value;

		var i:Int=_mcVector.length;
		while(i-->0)
		{
			_mcVector[i]._reverse=value;
		}
		
		return _reverse;
	}

	public var skipFrames(get_skipFrames, set_skipFrames):Bool;
 	private function get_skipFrames():Bool
	{
		return _skipFrames;
	}

	/**
	 * Indicates whether GAFMovieClip instance should skip frames when application fps drops down or play every frame not depending on application fps.
	 * Value false will force GAFMovieClip to play each frame not depending on application fps(the same behavior as in regular Flash Movie Clip).
	 * Value true will force GAFMovieClip to play animation "in time". And when application fps drops down it will start skipping frames(default behavior).
	 */
	private function set_skipFrames(value:Bool):Bool
	{
		_skipFrames=value;

		var i:Int=_mcVector.length;
		while(i-->0)
		{
			_mcVector[i]._skipFrames=value;
		}
		
		return _skipFrames;
	}

	/**  */
	public var pivotMatrix(get_pivotMatrix, null):Matrix;
 	private function get_pivotMatrix():Matrix
	{
		//HELPER_MATRIX.copyFrom(_pivotMatrix);
		HELPER_MATRIX.identity();

		//if(_pivotChanged)
		//{
			//HELPER_MATRIX.tx=pivotX;
			//HELPER_MATRIX.ty=pivotY;
		//}

		return HELPER_MATRIX;
	}

	public var transformationMatrix(get_transformationMatrix,set_transformationMatrix):Matrix;
	private function get_transformationMatrix():Matrix {
		return localTransform;
		
	}
	private function set_transformationMatrix(matrix:Matrix):Matrix {
		return localTransform=matrix;
	}	
	
	//--------------------------------------------------------------------------
	//
	//  STATIC METHODS
	//
	//--------------------------------------------------------------------------

	//[Inline]
	private static function getTransformMatrix(displayObject:IGAFDisplayObject, matrix:Matrix):Matrix
	{
		matrix.copyFrom(displayObject.pivotMatrix);
		return matrix;
	}

	
}