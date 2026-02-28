#pragma header

uniform vec3 colorReplaceEyes = vec3(31.0/255.0, 30.0/255.0, 39.0/255.0);

uniform vec3 colorReplaceHat = vec3(140.0/255.0, 151.0/255.0, 194.0/255.0);
uniform vec3 colorReplaceSkin = vec3(238.0/255.0, 214.0/255.0, 196.0/255.0);
uniform vec3 colorReplaceHair = vec3(71.0/255.0, 62.0/255.0, 56.0/255.0);

uniform vec3 colorReplaceShirt = vec3(215.0/255.0, 121.0/255.0, 156.0/255.0);
uniform vec3 colorReplaceStripe = vec3(101.0/255.0, 54.0/255.0, 98.0/255.0);

uniform vec3 colorReplacePants = vec3(97.0/255.0, 87.0/255.0, 146.0/255.0);
uniform vec3 colorReplaceShoes = vec3(56.0/255.0, 54.0/255.0, 68.0/255.0);

vec3 colorEyes = vec3(32.0/255.0, 30.0/255.0, 40.0/255.0);

vec3 colorHat = vec3(140.0/255.0, 151.0/255.0, 194.0/255.0);
vec3 colorSkin = vec3(238.0/255.0, 214.0/255.0, 196.0/255.0);
vec3 colorHair = vec3(71.0/255.0, 62.0/255.0, 56.0/255.0);

vec3 colorShirt = vec3(215.0/255.0, 121.0/255.0, 156.0/255.0);
vec3 colorStripe = vec3(101.0/255.0, 54.0/255.0, 98.0/255.0);

vec3 colorPants = vec3(97.0/255.0, 87.0/255.0, 146.0/255.0);
vec3 colorShoes = vec3(56.0/255.0, 54.0/255.0, 68.0/255.0);

bool inRange(vec3 rgb, float range)
{
	return all(lessThanEqual(rgb, vec3(range, range, range)));
}

void main()
{
	vec4 pixelColor = texture2D(bitmap, openfl_TextureCoordv);

	float range = 5.0 / 255.0;
	bool isEyes = false;

	if (inRange(abs(pixelColor.rgb - colorEyes.rgb), 1.0 / 255.0)) {
		pixelColor.rgb = colorReplaceEyes;
		isEyes = true;
	}

	if(inRange(abs(pixelColor.rgb - colorHat.rgb), range))
		pixelColor.rgb = colorReplaceHat.rgb;
	if(inRange(abs(pixelColor.rgb - colorSkin.rgb), range))
		pixelColor.rgb = colorReplaceSkin.rgb;
	if(inRange(abs(pixelColor.rgb - colorHair.rgb), range))
		pixelColor.rgb = colorReplaceHair.rgb;

	if(inRange(abs(pixelColor.rgb - colorShirt.rgb), range))
		pixelColor.rgb = colorReplaceShirt.rgb;
	if(inRange(abs(pixelColor.rgb - colorStripe.rgb), range))
		pixelColor.rgb = colorReplaceStripe.rgb;

	if(inRange(abs(pixelColor.rgb - colorPants.rgb), range))
		pixelColor.rgb = colorReplacePants.rgb;
	if(inRange(abs(pixelColor.rgb - colorShoes.rgb), range))
		pixelColor.rgb = colorReplaceShoes.rgb;

	if (!isEyes) {
		gl_FragColor = applyFlixelEffects(pixelColor);
	} else {
		gl_FragColor = pixelColor;
	}
}