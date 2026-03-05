import funkin.savedata.FunkinSave;
import funkin.options.Options;

if (!Options.devMode) {
	disableScript();
	return;
}

var speed:Float = 1;

function postUpdate(e:Float) {
	if (FlxG.keys.justPressed.END) {
		endSong();
		FlxG.timeScale = inst.pitch = vocals.pitch = speed = 1;
		return;
	}

	if (FlxG.keys.pressed.TWO) speed -= 0.01;
	if (FlxG.keys.justPressed.THREE) speed = 1;
	if (FlxG.keys.pressed.FOUR) speed += 0.01;

	FlxG.timeScale = inst.pitch = vocals.pitch = speed;

	player.cpu = speed != 1 || FunkinSave.save.data.botplay;
}