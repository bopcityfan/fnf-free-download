import flixel.FlxState;
import funkin.editors.charter.CharterSelection;
import funkin.editors.character.CharacterSelection;
import funkin.editors.stage.StageSelection;
import funkin.editors.alphabet.AlphabetEditor;
import Type;
import karaoke.util.ColorExtension;

using ColorExtension;

final options:Array<{name:String, state:FlxState}> = [
	{
		name: 'Chart Editor',
		state: CharterSelection
	},
	{
		name: 'Character Editor',
		state: CharacterSelection
	},
	{
		name: 'Stage Editor',
		state: StageSelection
	},
	{
		name: 'Alphabet Editor',
		state: AlphabetEditor
	}
];

final bgAlphaSelected:Float = 0.75;
final bgAlphaUnselected:Float = 0.5;

final textBrightnessSelected:Float = 1;
final textBrightnessUnselected:Float = 0.75;

var subCam:FlxCamera;

var optionSprites:Array<{bg:FunkinSprite, text:FunkinText}> = [];

var curSelected(default, set):Int = 0;
function set_curSelected(val:Int):Int {
	var newVal:Int = FlxMath.wrap(val, 0, options.length-1);
	return curSelected = newVal;
}

function create() {
	FlxG.mouse.visible = true;

	subCam = new FlxCamera();
	subCam.bgColor = 0;
	FlxG.cameras.add(subCam, false);

	final heightDivision:Int = Std.int(FlxG.height/options.length);

	for (index => data in options) {
		var bg:FunkinSprite = new FunkinSprite(0, heightDivision*index).makeGraphic(FlxG.width, heightDivision, 0xFF000000);
		bg.cameras = [subCam];
		bg.alpha = curSelected == index ? bgAlphaSelected : bgAlphaUnselected;
		add(bg);

		var text:FunkinText = new FunkinText(10, bg.y + 13, bg.width, data.name, 32, true);
		text.cameras = [subCam];
		text.font = Paths.font("Pixellari.ttf");
		text.textField.antiAliasType = 0;
		text.textField.sharpness = 400;
		text.borderSize = 3;
		add(text);

		optionSprites.push({
			bg: bg,
			text: text
		});
	}
}

function update(elapsed:Float) {
	if (controls.BACK) {
		close();
		return;
	}

	for (index => spr in optionSprites) {
		if (FlxG.mouse.justMoved && CoolUtil.mouseOverlaps(spr.bg)) {
			curSelected = index;
		}

		final selected:Bool = curSelected == index;

		spr.bg.alpha = lerp(spr.bg.alpha, selected ? bgAlphaSelected : bgAlphaUnselected, 0.32);

		final brightness:Float = lerp(spr.text.color.brightness(), selected ? textBrightnessSelected : textBrightnessUnselected, 0.32);
		spr.text.color = FlxColor.fromRGBFloat(brightness, brightness, brightness);
	}

	if (controls.DOWN_P) {
		curSelected += 1;
	} else if (controls.UP_P) {
		curSelected -= 1;
	}

	if (controls.ACCEPT || FlxG.mouse.justPressed) {
		FlxG.sound.play(Paths.sound("menus/josh")).persist = true;
		FlxG.switchState(Type.createInstance(options[curSelected].state, []));
	}
}

function onClose() {
	FlxG.cameras.remove(subCam, true);

	for (spr in optionSprites) {
		optionSprites.remove(spr);

		spr.bg.destroy();
		spr.text.destroy();
	}
}