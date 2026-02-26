import flixel.util.FlxSpriteUtil;
import flixel.util.FlxGradient;

class KaraokeText extends FunkinText {
	public var gradient(default, set):Array<FlxColor> = [];
	private function set_gradient(val:Array<FlxColor>):Array<FlxColor> {
		if (gradientEnabled) {
			setGradient(val);
		}

		return gradient = val;
	}

	public var gradientEnabled(default, set):Bool = false;
	private function set_gradientEnabled(val:Bool):Bool {
		if (val) {
			setGradient(gradient);
		} else {
			// idk how else to refresh it
			final oldText:String = text;
			text = "";
			text = oldText;
		}

		return gradientEnabled = val;
	}

	public function new(X:Float, Y:Float, FieldWidth:Float = 0, ?Text:String, Size:Int = 16, Border:Bool = false) {
		if (Text == null) {
			Text = '';
		}
		if (Size == null) {
			Size = 16;
		}
		if (Border == null) {
			Border = false;
		}

		super(X, Y, FieldWidth, Text, Size, Border);

		antialiasing = false;

		// lunarcleint figured this out thank u lunar holy shit 🙏
		textField.antiAliasType = 0; // advanced
		textField.sharpness = 400; // max i think idk thats what it says

		font = Paths.font("Pixellari.ttf");
	}

	private function setGradient(colors:Array<FlxColor>) {
		return FlxSpriteUtil.alphaMask(
			this,
			FlxGradient.createGradientBitmapData(width, height, colors),
			pixels
		);
	}
}