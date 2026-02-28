#pragma header

uniform vec4 colorReplaceHat;
uniform vec4 colorReplaceSkin;
uniform vec4 colorReplaceHair;

uniform vec4 colorReplaceShirt;
uniform vec4 colorReplaceStripe;

uniform vec4 colorReplacePants;
uniform vec4 colorReplaceShoes;

vec4 colorHat = vec4(140.0/255.0, 151.0/255.0, 194.0/255.0, 1.0);
vec4 colorSkin = vec4(238.0/255.0, 214.0/255.0, 196.0/255.0, 1.0);
vec4 colorHair = vec4(71.0/255.0, 62.0/255.0, 56.0/255.0, 1.0);

vec4 colorShirt = vec4(215.0/255.0, 121.0/255.0, 156.0/255.0, 1.0);
vec4 colorStripe = vec4(101.0/255.0, 54.0/255.0, 98.0/255.0, 1.0);

vec4 colorPants = vec4(97.0/255.0, 87.0/255.0, 146.0/255.0, 1.0);
vec4 colorShoes = vec4(56.0/255.0, 54.0/255.0, 68.0/255.0, 1.0);

float range = 5.0 / 255.0;
vec3 rangeVec = vec3(range, range, range);

bool inRange(vec3 rgb)
{
	return all(lessThanEqual(rgb, rangeVec));
}

void main()
{
	vec4 pixelColor = texture2D(bitmap, openfl_TextureCoordv);

	if(inRange(abs(pixelColor.rgb - colorHat.rgb)))
		pixelColor.rgb = colorReplaceHat.rgb;
	if(inRange(abs(pixelColor.rgb - colorSkin.rgb)))
		pixelColor.rgb = colorReplaceSkin.rgb;
	if(inRange(abs(pixelColor.rgb - colorHair.rgb)))
		pixelColor.rgb = colorReplaceHair.rgb;

	if(inRange(abs(pixelColor.rgb - colorShirt.rgb)))
		pixelColor.rgb = colorReplaceShirt.rgb;
	if(inRange(abs(pixelColor.rgb - colorStripe.rgb)))
		pixelColor.rgb = colorReplaceStripe.rgb;

	if(inRange(abs(pixelColor.rgb - colorPants.rgb)))
		pixelColor.rgb = colorReplacePants.rgb;
	if(inRange(abs(pixelColor.rgb - colorShoes.rgb)))
		pixelColor.rgb = colorReplaceShoes.rgb;

	// apply the colorTransform stuff that flixel_texture2D normally does (stolen from FlxGraphicsShader lol!!!)
	if (hasColorTransform) {
		mat4 colorMultiplier = mat4(0);
		colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
		colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
		colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
		colorMultiplier[3][3] = openfl_ColorMultiplierv.w;

		pixelColor = clamp(openfl_ColorOffsetv + (pixelColor * colorMultiplier), 0.0, 1.0);
	}

	// alpha fix (also stolen from FlxGraphicsShader)
	if (pixelColor.a > 0.0) gl_FragColor = vec4(pixelColor.rgb * pixelColor.a * openfl_Alphav, pixelColor.a * openfl_Alphav);
	else gl_FragColor = vec4(pixelColor.rgb / pixelColor.a, pixelColor.a);
}