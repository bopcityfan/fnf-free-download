import karaoke.backend.utils.ColorExtension;
import karaoke.backend.utils.SpriteUtil;
import karaoke.backend.utils.SpriteUtil.DrawPassType;

using ColorExtension;
using SpriteUtil;

static var playerSkin:CustomShader;
static var playerEyes:CustomShader;

function postCreate() {
	shader = playerSkin = new CustomShader("player/colorswap");
	playerEyes = new CustomShader("player/eyes");
}

function destroy() {
	playerSkin = null;
	playerEyes = null;
}