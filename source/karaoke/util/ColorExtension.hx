package karaoke.util;

using StringTools;

class ColorExtension {
	static public function maxColor(color:FlxColor):Int {
		return Math.max(redFloat(color), Math.max(greenFloat(color), blueFloat(color)));
	}

	static public function minColor(color:FlxColor):Int {
		return Math.min(redFloat(color), Math.min(greenFloat(color), blueFloat(color)));
	}

	static public function red(color:FlxColor):Int {
		return (color >> 16) & 0xff;
	}

	static public function green(color:FlxColor):Int {
		return (color >> 8) & 0xff;
	}

	static public function blue(color:FlxColor):Int {
		return (color) & 0xff;
	}

	static public function alpha(color:FlxColor):Int {
		return (color >> 24) & 0xff;
	}

	static public function redFloat(color:FlxColor):Float {
		return red(color) / 255;
	}

	static public function greenFloat(color:FlxColor):Float {
		return green(color) / 255;
	}

	static public function blueFloat(color:FlxColor):Float {
		return blue(color) / 255;
	}

	static public function alphaFloat(color:FlxColor):Float {
		return alpha(color) / 255;
	}

	static public function hue(color:FlxColor):Float {
		var hueRad = Math.atan2(Math.sqrt(3) * (greenFloat(color) - blueFloat(color)), 2 * redFloat(color) - greenFloat(color) - blueFloat(color));
		var hue:Float = 0;
		if (hueRad != 0)
			hue = 180 / Math.PI * hueRad;

		return hue < 0 ? hue + 360 : hue;
	}

	static public function saturation(color:FlxColor):Float {
		return (maxColor(color) - minColor(color)) / brightness(color);
	}

	static public function brightness(color:FlxColor):Float {
		return maxColor(color);
	}

	static public function lightness(color:FlxColor):Float {
		return (maxColor(color) + minColor(color)) / 2;
	}

	static public function cyan(color:FlxColor):Float {
		return (1 - redFloat(color) - black(color)) / brightness(color);
	}

	static public function magenta(color:FlxColor):Float {
		return (1 - greenFloat(color) - black(color)) / brightness(color);
	}

	static public function yellow(color:FlxColor):Float {
		return (1 - blueFloat(color) - black(color)) / brightness(color);
	}

	static public function black(color:FlxColor):Float {
		return 1 - brightness(color);
	}

	static public function rgb(color:FlxColor):FlxColor {
		return color & 0x00ffffff;
	}

	// u need to do ColorExtension.toHexString(color, includeAlpha, includePrefix) for this one, idk why but the other vars are false if u don't
	static public function toHexString(color:FlxColor, includeAlpha:Bool = true, includePrefix:Bool = true):String {
		return (includePrefix ? "0x" : "") + (includeAlpha ? alpha(color).hex(2) : "") + red(color).hex(2) + green(color).hex(2) + blue(color).hex(2);
	}

	static public function vec3(color:FlxColor):Array<Float> {
		return [redFloat(color), greenFloat(color), blueFloat(color)];
	}

	static public function vec4(color:FlxColor):Array<Float> {
		return [redFloat(color), greenFloat(color), blueFloat(color), alphaFloat(color)];
	}
}