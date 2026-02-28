import karaoke.backend.utils.ColorExtension;
using ColorExtension;

var skin:CustomShader;
var eyes:CustomShader;
function postCreate() {
	shader = skin = new CustomShader("player/colorswap");

	if (PlayState.instance.curSong == "stars") {
		eyes = new CustomShader("player/eyes");
		eyes.colorReplaceEyes = 0xFFFFFFFF.vec3();

		onDraw = (spr:Character) -> {
			spr.color = 0xFF614C75;
			spr.offset.set(-spr.globalOffset.x, -spr.globalOffset.y);
			spr.alpha = 1;
			spr.shader = skin;
			spr.draw();

			spr.setColorTransform(0, 0, 0, 0.45);
			spr.offset.set(-spr.globalOffset.x + -4, -spr.globalOffset.y);
			spr.draw();

			spr.color = 0xFFFFFFFF;
			spr.offset.set(-spr.globalOffset.x, -spr.globalOffset.y);
			spr.alpha = 1;
			spr.shader = eyes;
			spr.draw();
		};
	}

	// applyPlayerSkin(skin, 'dude');
}