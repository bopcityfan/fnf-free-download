import funkin.savedata.FunkinSave;

var lastSwagWidth:Int = 0; // so we can put it back laterrrr

function create() {
	lastSwagWidth = Note.swagWidth;
	Note.swagWidth = 44;
}

function onNoteHit(event) {
	event.preventStrumGlow();
	event.showSplash = false;

	if (event.player) {
		if (event.noteType == "hurt") {
			return;
		}

		if (!event.note.isSustainNote) {
			flow += 0.05;
			flow = FlxMath.bound(flow, 0, 1);
			hud?.onFlowUpdate(flow);
		}

		event.healthGain = event.note.isSustainNote ? 0.02 : 0.05;
		event.score = event.note.isSustainNote ? 25 : 100;
	}
}

if (!FunkinSave.save.data.dxStyledStrums) {
	function onInputUpdate(event) {
		for (index => value in event.justPressed) {
			if (value) {
				var strum:Strum = event.strumLine.members[index];
				strum.alpha = 0.5;
				strum.color = 0xFF808080;
				new FlxTimer().start(0.1, (t:FlxTimer) -> {
					strum.alpha = 1;
					strum.color = 0xFFFFFFFF;
					t.destroy();
				});
			}
		}
	}
} else {
	function update(elapsed:Float) {
		for (sL in strumLines.members) {
			if (!sL.cpu) {
				for (strum in sL.members) {
					strum.color = ["pressed","confirm"].contains(strum.getAnim()) ? 0xFF979797 : 0xFFFFFFFF;
				}
			}
		}
	}
}

// function postUpdate(elapsed:Float) {
// 	for (sl in strumLines.members) {
// 		for (note in sl.notes.members) {
// 			if (note.isSustainNote) {
// 				note.y -= 24;
// 			} else {
// 				note.y -= 0;
// 			}
// 		}
// 	}
// }

function onPlayerMiss(event) {
	if (!event.mustHit) {
		return;
	}

	flow -= 0.1;
	flow = FlxMath.bound(flow, 0, 1);
	hud?.onFlowUpdate(flow);

	event.healthGain = -(1+(4*(1-flow)))/50;
	event.score = -50;

	event.cancelMissSound();
	var missSound:FlxSound = FlxG.sound.load(Paths.sound("game/owch"));
	missSound.onComplete = () -> {
		if (missSound != null) {
			FlxG.sound.destroySound(missSound);
		}
	}
	missSound.pitch = 0.6 + FlxG.random.float(0, 0.8);
	missSound.play();
}

function onNoteCreation(event) {
	event.cancel();

	// if (event.noteType != null) {
	// 	return;
	// }

	var note = event.note;
	note.frames = Paths.getFrames('game/notes/${hudSkin}');
	switch(hudSkin) {
		default:
			if (!note.isSustainNote)
				note.animation.addByPrefix('scroll', ['purple_note', 'blue_note', 'green_note', 'red_note'][event.note.noteData], 0, true);
			else {
				note.animation.addByPrefix('hold', ['purple_hold', 'blue_hold', 'green_hold', 'red_hold'][event.note.noteData], 0, true);
				note.animation.addByPrefix('holdend', ['purple_cap', 'blue_cap', 'green_cap', 'red_cap'][event.note.noteData], 0, true);
			}
		case "gaw":
			if (!note.isSustainNote)
				note.animation.addByPrefix('scroll', ['left', 'down', 'up', 'right'][event.note.noteData], 0, true);
			else {
				note.animation.addByPrefix('hold', "hold", 0, true);
				note.animation.addByPrefix('holdend', "hold_cap", 0, true);
			}
	}

	note.updateHitbox();
}

function onStrumCreation(event) {
    event.cancelAnimation();
	event.strum.setPosition(FlxG.width*(switch event.player {
		default: 0.53;
		case 0: 0.025;
	}) + (Note.swagWidth * event.strumID), 24);

	event.strum.scrollSpeed = 0.45 * PlayState.SONG.scrollSpeed;

	event.cancel();

	var strum = event.strum;
	strum.frames = Paths.getFrames('game/notes/${hudSkin}');
	strum.animation.addByPrefix('static', event.animPrefix, 0, true);
	strum.animation.addByPrefix('pressed', event.animPrefix, 0, true); // so it'll stop tracing stupid shit

	strum.updateHitbox();
}

function destroy() {
	noteskin = "default";
	Note.swagWidth = lastSwagWidth;
}