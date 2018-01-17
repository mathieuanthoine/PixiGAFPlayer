package com.github.haxePixiGAF.utils;

import haxe.io.Bytes;
import haxe.io.BytesInput;

/**
 * AS3 ByteArray "Wrapper"
 * @author Mathieu Anthoine
 */
class GAFBytesInput extends BytesInput {

	public function new(b:Bytes, ?pos:Int, ?len:Int) 
	{
		super(b, pos, len);	
	}	
	
	// AS3 readByte
	public function readSByte():Int {
		var lByte:Int = readByte();
		return lByte > 128 ? lByte-256 : lByte;
	}
	
	public function readUnsignedByte ():UInt {
		return readByte();
	}
	
	public function readShort():Int {
		var lByte:Int = readUInt16();
		return lByte > 32767 ? lByte-65536 : lByte;
	}	
	
	public function readUnsignedShort ():UInt {
		return readUInt16();
	}
	
	public function readInt ():Int {
		return readUInt32();
		//var lInt:Float = readUInt32();
		//lInt = lInt > 2147483648 ? lInt - 4294967296 : lInt;
		//return cast(lInt, Int);
	}
	
	public function readUnsignedInt():UInt {
		return untyped readUInt32();
	}

	/**
	 * may return an Unsigned Int32 but UInt32 are converted to Int32 if they are above 2147483648
	 * @return signed Int32
	 */
	private function readUInt32 ():UInt {
		var lA:UInt = readUInt16();
		var lB:UInt = readUInt16();
		return (lB << 16) + lA;
	}
	
	public function readBoolean ():Bool {
		return readSByte() != 0;
	}
	
	public function readUTF ():String {
		return readString(readUnsignedShort());
	}
	
	
}