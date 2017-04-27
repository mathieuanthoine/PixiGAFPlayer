/**
 * Created by Nazar on 27.11.2014.
 */
package;

class SequencePlaybackInfo
{
	private var _name:String;
	private var _looped:Bool;

	public function new(name:String, looped:Bool)
	{
		_name=name;
		_looped=looped;
	}

	public var name(get_name, null):String;
 	private function get_name():String
	{
		return _name;
	}

	public var looped(get_looped, null):Bool;
 	private function get_looped():Bool
	{
		return _looped;
	}
}