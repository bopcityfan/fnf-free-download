import funkin.menus.ModSwitchMenu;
import funkin.options.OptionsMenu;
import funkin.backend.MusicBeatState;

var bg:FunkinSprite;
var options:FunkinSprite;
var optionList:Array<String> = ['StoryMenu', 'Freeplay', 'Settings'];
var curSelected:Int = 0;

function create() {
	playMenuMusic();

	bg = new FunkinSprite().loadGraphic(Paths.image('menus/backgrounds/dawn'));
	bg.scale.set(2, 2);
	bg.updateHitbox();
	add(bg);

	options = new FunkinSprite().loadSprite(Paths.image('menus/mainMenu/options'));
	for (index=>name in optionList) {
		options.addAnim(name, 'spr_titlewords2_${index}', 0, true);
	}
	options.scale.set(2, 2);
	options.updateHitbox();
	options.screenCenter();
	add(options);
	options.playAnim('StoryMenu', true);
}

function update(elapsed:Float) {
	if (controls.ACCEPT) {
		if (Assets.exists(Paths.script('data/states/menus/${optionList[curSelected]}'))) {
			FlxG.sound.play(Paths.sound("menus/josh")).persist = true;
			FlxG.switchState(new ModState('menus/${optionList[curSelected]}'));
		}
	}

	// if (FlxG.keys.justPressed.SEVEN) {
	// 	persistentUpdate = false;
	// 	openSubState(new ModSubState('substates/editors/EditorSelect'));
	// }

	// if (controls.SWITCHMOD) {
	// 	persistentUpdate = false;
	// 	openSubState(new ModSubState('substates/menus/ModSwitch'));
	// }

	if (controls.DOWN_P || controls.UP_P) {
		curSelected = FlxMath.wrap(curSelected + (controls.DOWN_P ? 1 : -1), 0, optionList.length-1);
		options.playAnim(optionList[curSelected], true);
		options.x = -22;
		options.y = -22;
	}

	bg.y = CoolUtil.fpsLerp(bg.y, (-125/1.15) * curSelected, 0.06);
}