import karaoke.game.hud.HudBase;
import karaoke.game.hud.DefaultHud;
import karaoke.game.hud.GAWHud;

public var hud:HudBase;
public var hudSkin:String = "default";

function wipeBaseContent() {
	updateIconPositions = null;
	updateRatingStuff = null;

	iconArray.remove(iconP1);
	iconArray.remove(iconP2);

	for (i in [iconP1, iconP2, healthBarBG, healthBar, scoreTxt, missesTxt, accuracyTxt]) {
		remove(i);
		i = null;
	}
}

function create() {
	hud = switch(hudSkin) {
		default:
			new DefaultHud();
		case 'gaw':
			new GAWHud();
	}
	hud.spriteGroup.cameras = [camHUD];
	add(hud.spriteGroup);

	hud.create();
}

function postCreate() {
	wipeBaseContent();

	camHUD.pixelPerfectRender = true;
	canPause = false;
	for (sl in strumLines.members) {
        for (note in sl.notes.members) {
            note.alpha = 1;
		}
	}

	hud.postCreate();

	// var ref:FunkinSprite = new FunkinSprite().loadGraphic(Paths.image('image'));
	// ref.zoomFactor = 0;
	// ref.scrollFactor.set();
	// ref.scale.set(0.5, 0.5);
	// ref.updateHitbox();
	// ref.cameras = [camHUD];
	// ref.alpha = 0.5;
	// ref.color = 0xFFFF0000;
	// insert(0, ref);
}

function onCountdown(event) {
	hud.onCountdown(event);
}

function onPostCountdown(event) {
	hud.onPostCountdown(event);
}

function onSongStart() {
	canPause = true;
	hud.onSongStart();
}

function onNoteHit(event) {
	hud.onNoteHit(event);
}

function onPlayerMiss(event) {
	hud.onPlayerMiss(event);
}

function onPostPlayerMiss(event) {
	hud.onPostPlayerMiss(event);
}

function postUpdate(elapsed:Float) {
	hud.postUpdate(elapsed);
}