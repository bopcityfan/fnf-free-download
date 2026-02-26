import funkin.editors.character.CharacterEditor;
import openfl.system.Capabilities;

// GO FUCK YOURSELF FUCK OFF I HATE YOU SO FUCKING MUCH OH MY GODDD
// 2026 update not sure why i wrote that
function create() {
	resizeGame(1280, 720, 1280, 720);
}

function destroy() {
	if (FlxG.game._requestedState is CharacterEditor) {
		return;
	}

	resizeGame(gameSize.X, gameSize.Y, gameSize.X*2, gameSize.Y*2);
}