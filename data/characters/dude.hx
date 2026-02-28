import karaoke.backend.utils.ColorExtension;
using ColorExtension;

var skin:CustomShader;
function postCreate() {
	shader = skin = new CustomShader("player/colorswap");

	if (PlayState.instance.curSong == "stars") {
		shader.colorReplaceEyes = 0xFFFFFFFF.vec3();
	}

	// applyPlayerSkin(skin, 'dude');
}