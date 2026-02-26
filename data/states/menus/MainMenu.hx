import funkin.backend.system.Flags;

final optionList:Array<String> = ['StoryMenu', 'Freeplay', 'Settings'];

var bg:FunkinSprite;
var options:FunkinSprite;

var curSelected(default, set):Int = 0;
function set_curSelected(val:Int):Int {
	var newVal:Int = FlxMath.wrap(val, 0, optionList.length-1);
	options?.playAnim(optionList[newVal], true);
	return curSelected = newVal;
}

function create() {
	playMenuMusic();

	bg = new FunkinSprite().loadGraphic(Paths.image('menus/backgrounds/dawn', null, true));
	bg.scale.set(2, 2);
	bg.updateHitbox();
	add(bg);

	options = new FunkinSprite().loadSprite(Paths.image('menus/mainMenu/options', null, true));
	for (index=>name in optionList) {
		options.addAnim(name, 'spr_titlewords2_${index}', 0, true);
	}
	options.scale.set(2, 2);
	options.updateHitbox();
	options.screenCenter();
	add(options);
	options.playAnim('StoryMenu', true);
}

function accept() {
	if (!Assets.exists(Paths.script('data/states/menus/${optionList[curSelected]}'))) {
		return;
	}

	FlxG.sound.play(Paths.sound("menus/josh")).persist = true;
	FlxG.switchState(new ModState('menus/${optionList[curSelected]}'));
}

function update(elapsed:Float) {
	if (controls.ACCEPT) {
		accept();
	}

	if (controls.DEV_ACCESS && !Flags.DISABLE_EDITORS) {
		persistentUpdate = false;
		openSubState(new ModSubState('substates/editors/EditorSelect'));
	}

	// if (controls.SWITCHMOD) {
	// 	persistentUpdate = false;
	// 	openSubState(new ModSubState('substates/menus/ModSwitch'));
	// }

	if (controls.DOWN_P) {
		curSelected += 1;
	} else if (controls.UP_P) {
		curSelected -= 1;
	}

	bg.y = CoolUtil.fpsLerp(bg.y, (-125/1.15) * curSelected, 0.06);
}