import karaoke.game.Speaker;
import karaoke.game.Speaker.SpeakerMode;

var bombSounds:Array<FlxSound> = [];

var oldMode:SpeakerMode;
var errorText:FunkinSprite;

function create() {
	bombSounds = [
		FlxG.sound.load(Paths.sound('game/weeknd2/bomb1')),
		FlxG.sound.load(Paths.sound('game/weeknd2/bomb2')),
		FlxG.sound.load(Paths.sound('game/weeknd2/bomb3'))
	];
}

function postCreate() {
	if (ladySpeaker == null) {
		return;
	}

	errorText = new FunkinSprite(24, 13).loadSprite(Paths.image('game/speaker/errorText'));
	errorText.visible = false;
	ladySpeaker?.add(errorText);

	oldMode = ladySpeaker?.mode;
}

var timer:Float = 0;
function update(elapsed:Float) {
	if (ladySpeaker == null || !errorText.visible) {
		return;
	}

	timer += elapsed;
	errorText.y = (196) + (Math.sin(timer * 3.75) + 1) * 2;
}

var lastTimer:FlxTimer;
function speakerError() {
	if (ladySpeaker == null || lastTimer != null && !lastTimer.finished) {
		return;
	}

	ladySpeaker.mode = SpeakerMode.NONE;
	ladySpeaker.main.playAnim("off", true);

	ladySpeaker.light.visible = true;
	ladySpeaker.light.playAnim("error", true);
	ladySpeaker.light.animation.timeScale = 1;

	errorText.visible = true;

	lastTimer = new FlxTimer().start(0.5, (tmr:FlxTimer) -> {
		ladySpeaker.mode = oldMode;
		ladySpeaker.main.playAnim("colors", false);
		ladySpeaker.autoProgress(curBeat);

		ladySpeaker.light.visible = false;
		ladySpeaker.light.animation.timeScale = 0;

		errorText.visible = false;

		lastTimer = null;
	});
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

	speakerError();
}

function onPlayerMiss(event) {
	if (event.noteType != "hurt") {
		return;
	}

	event.preventMissSound();
	event.preventResetCombo();
	event.preventStunned();
	event.preventAnim();
	event.preventVocalsMute();

	event.score = 0;
	event.misses = 0;
	event.healthGain = 0;

	speakerError();
}

function onNoteCreation(event) {
	if (event.noteType != "hurt") {
		return;
	}

	var note = event.note;
	note.frames = Paths.getFrames('game/notes/hurt');
	note.animation.addByPrefix('scroll', ['purple', 'blue', 'green', 'red'][event.note.noteData], 0, true);

	note.updateHitbox();

	event.note.avoid = !event.note.strumLine.opponentSide;
}