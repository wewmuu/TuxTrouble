import flixel.util.FlxColor;
import openfl.display.Sprite;
import flixel.FlxSprite;

/**
 * designed to draw a Open FL Sprite as a FlxSprite (to allow layering and auto sizing for haxeflixel cameras)
 * Custom made for Kade Engine
 * (From Kade Engine 1.5.4)
 *
 * Slightly modified to let it update every frame if set to so that OpenFl video
 * can play through it and be layered (thanks for making this kade, I would be
 * stuck using thumbnail previews for html5 freeplay if not for this)
 */
class OFLSprite extends FlxSprite
{
    public var flSprite:Sprite;

    public var alwaysUpdate:Bool = false;

    public function new(x, y, width, height, Sprite:Sprite, ?au:Bool = false)
    {
        super(x,y);

        alwaysUpdate = au;

        makeGraphic(width,height,FlxColor.TRANSPARENT);

        flSprite = Sprite;

        pixels.draw(flSprite);
    }

    private var _frameCount:Int = 0;

	override function update(elapsed:Float)
    {
        if (_frameCount != 2)
        {
            pixels.draw(flSprite);
            _frameCount++;
        }
        else if (alwaysUpdate)
        {
          pixels.draw(flSprite);
        }
    }

    public function updateDisplay()
    {
        pixels.draw(flSprite);
    }
}
