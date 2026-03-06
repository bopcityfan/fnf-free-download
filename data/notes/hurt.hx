var bombSounds:Array<FlxSound> = [];

function create() {
	bombSounds = [
		FlxG.sound.load(Paths.sound('game/weeknd2/bomb1')),
		FlxG.sound.load(Paths.sound('game/weeknd2/bomb2')),
		FlxG.sound.load(Paths.sound('game/weeknd2/bomb3'))
	];
}

function onNoteHit(event) {
	if (event.noteType != "hurt") {
		return;
	}

	if (event.player) {
		event.preventAnim();

		event.misses = true;
		event.score = -50;
		event.healthGain = -0.25;
		event.countAsCombo = false;
		event.countScore = false;
		misses += 1;

		bombSounds[FlxG.random.int(0, 2)].play();
	} else {
		event.animSuffix = "-alt";
	}
}

function onPlayerMiss(event) {
	if (event.noteType != "hurt") {
		return;
	}

	event.cancel();
}

function onNoteCreation(event) {
	if (event.noteType != "hurt") {
		return;
	}

	var note = event.note;
	note.frames = Paths.getFrames('game/notes/hurt');
	note.animation.addByPrefix('scroll', ['purple', 'blue', 'green', 'red'][event.note.noteData], 0, true);

	note.updateHitbox();

	event.mustHit = false;
}