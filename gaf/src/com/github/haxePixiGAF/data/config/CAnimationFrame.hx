package com.github.haxePixiGAF.data.config;

/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * 
 */
class CAnimationFrame
{
	// --------------------------------------------------------------------------
	//
	// PUBLIC VARIABLES
	//
	// --------------------------------------------------------------------------
	// --------------------------------------------------------------------------
	//
	// PRIVATE VARIABLES
	//
	// --------------------------------------------------------------------------
	private var _instancesDictionary:Map<String,CAnimationFrameInstance>;
	private var _instances:Array<CAnimationFrameInstance>;
	private var _actions:Array<CFrameAction>;

	private var _frameNumber:Int=0;

	// --------------------------------------------------------------------------
	//
	// CONSTRUCTOR
	//
	// --------------------------------------------------------------------------
	public function new(frameNumber:Int)
	{
		_frameNumber=frameNumber;

		_instancesDictionary=new Map<String,CAnimationFrameInstance>();
		_instances=new Array<CAnimationFrameInstance>();
	}

	// --------------------------------------------------------------------------
	//
	// PUBLIC METHODS
	//
	// --------------------------------------------------------------------------
	public function clone(frameNumber:Int):CAnimationFrame
	{
		var result:CAnimationFrame=new CAnimationFrame(frameNumber);

		for(instance in _instances)
		{
			result.addInstance(instance);
			// .clone());
		}

		return result;
	}

	public function addInstance(instance:CAnimationFrameInstance):Void
	{
		if(_instancesDictionary[instance.id]!=null)
		{
			if(instance.alpha!=null)
			{
				_instances[_instances.indexOf(_instancesDictionary[instance.id])]=instance;

				_instancesDictionary[instance.id]=instance;
			}
			else
			{
				// Poping the last element and set it as the removed element
				var index:Int=_instances.indexOf(_instancesDictionary[instance.id]);
				// If index is last element, just pop
				if(index==(_instances.length - 1))
				{
					_instances.pop();
				}
				else
				{
					_instances[index]=_instances.pop();
				}

				_instancesDictionary.remove(instance.id);
			}
		}
		else
		{
			_instances.push(instance);

			_instancesDictionary[instance.id]=instance;
		}
	}

	public function addAction(action:CFrameAction):Void
	{
		if (_actions==null) _actions =new Array<CFrameAction>();
		_actions.push(action);
	}

	public function sortInstances():Void
	{
		_instances.sort(sortByZIndex);
	}

	public function getInstanceByID(id:String):CAnimationFrameInstance
	{
		return _instancesDictionary[id];
	}

	// --------------------------------------------------------------------------
	//
	// PRIVATE METHODS
	//
	// --------------------------------------------------------------------------
	private function sortByZIndex(instance1:CAnimationFrameInstance, instance2:CAnimationFrameInstance):Int
	{
		if(instance1.zIndex<instance2.zIndex)
		{
			return -1;
		}
		else if(instance1.zIndex>instance2.zIndex)
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}

	// --------------------------------------------------------------------------
	//
	// OVERRIDDEN METHODS
	//
	// --------------------------------------------------------------------------
	// --------------------------------------------------------------------------
	//
	// EVENT HANDLERS
	//
	// --------------------------------------------------------------------------
	// --------------------------------------------------------------------------
	//
	// GETTERS AND SETTERS
	//
	// --------------------------------------------------------------------------
	public var instances(get_instances, null):Array<CAnimationFrameInstance>;
 	private function get_instances():Array<CAnimationFrameInstance>
	{
		return _instances;
	}

	public var frameNumber(get_frameNumber, null):Int;
 	private function get_frameNumber():Int
	{
		return _frameNumber;
	}
	public var actions(get_actions, null):Array<CFrameAction>;
 	private function get_actions():Array<CFrameAction>
	{
		return _actions;
	}
}