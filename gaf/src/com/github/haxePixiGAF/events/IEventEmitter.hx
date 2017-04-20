package com.github.haxePixiGAF.events;

/**
 * Equivalent to AS3 IEventDispatcher
 * @author Mathieu Anthoine
 */
interface IEventEmitter 
{
	function listeners(event:String):Array<Dynamic>;
	function emit(event:String, ?a1:Dynamic, ?a2:Dynamic, ?a3:Dynamic, ?a4:Dynamic, ?a5:Dynamic):Bool;
	function on(event:String, fn:Dynamic -> Void, ?context:Dynamic):Void;
	function once(event:String, fn:Dynamic -> Void, ?context:Dynamic):Void;
	function addListener(event:String, fn:Dynamic -> Void, ?context:Dynamic):Void;
	function off(event:String, fn:Dynamic -> Void, ?once:Bool):Void;
	function removeListener(event:String, fn:Dynamic -> Void, ?once:Bool):Void;
	function removeAllListeners(?event:String):Void;
}