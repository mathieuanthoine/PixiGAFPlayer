package com.github.haxePixiGAF.utils;
import pixi.interaction.EventEmitter;

/**
 * Class that adds equivalents to AS3 methods
 * @author Mathieu Anthoine
 */
class EventEmitterUtility
{

	public static function hasEventListener(pEmitter:EventEmitter,pEvent:String):Bool {
		if (pEmitter.listeners==null) return false;
		return pEmitter.listeners(pEvent).length > 0;
	}
	
}