package com.github.haxePixiGAF.display;

/**
 * @author Mathieu Anthoine
 */
interface IAnimatable 
{
  /** Advance the time by a number of seconds. @param time in seconds. */
	public function advanceTime(time:Float):Void;
}