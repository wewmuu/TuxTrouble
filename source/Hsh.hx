package;

import lime.utils.Assets;
import flixel.FlxG;

using StringTools;

/*
 * Was going to be for a easter egg with score shit. I never finished it.
 * It's basically nerd shit.
*/


class Hsh
{

	private static var hshrc:Array<Array<String>>;
	private static var hsfiles:Array<String>;

	public static function roll():String
	{

    hshrc = getHshrc();
    hsfiles = getFilenames();

		var funny:Array<String> = FlxG.random.getObject(hshrc);
    var line:String;

		line = printCommandString(funny[1], funny[2]);

    return funny[0] + " " + line;

	}

	// taken from titlestate intro text
	// the first in a group of the array is the shell string itself
	// the second is the name of the shell it belongs to
	// the third is the operating system (or the name of the coreutils that should be in mind when making the gag)
	// the coreutils will most likely make no fuckin diffrence, but ya never know.
	private static function getHshrc():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('hshrc'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	private static function getFilenames():Array<String>
	{
		var fullText:String = Assets.getText(Paths.txt('highscore'));

		var swagGoodArray:Array<String> = fullText.split('\n');

		return swagGoodArray;
	}

	// PRINTING THE HIGHSCORE //

	private static function printCommandString(shell:String, coreutils:String):String
	{
		var out:String = 'braphog';
		var filename:String = FlxG.random.getObject(hsfiles);
		var options:Array<String> = ['cat', 'printf', 'diff', 'cp', 'dd']; // I was hesitant to include more and less for accuracy reasons, but fuck it who cares.

		if (shell == 'zsh')
			options.push('pipe');

		// pick and choose an option

		switch (FlxG.random.getObject(options))
		{
			case 'cat':
				out = 'cat '+filename;
			case 'printf':
				out = 'printf \'%s\' \"$(<'+filename+')\"';
			case 'diff':
				out = 'diff -N -a --line-format=\"%L\" '+filename+' braap';
			case 'cp':
				out = 'cp '+filename+' /dev/stdout';
			case 'dd':
			{
				switch (coreutils)
				{
					case 'gnu':
						out = 'dd if='+filename+' of=/dev/stdout status=none';
					case 'mac' | 'busybox'| 'freebsd' | 'openbsd':
						out = 'dd if='+filename+' of=/dev/stdout &> /dev/null';
				}
			}
			case 'pipe': // only an option fo zsh
				out = '<'+filename;
			case 'more': // lol
				out = 'more '+filename;
			case 'less': // lol
				out = 'less '+filename;

		}

		return out;

	}

}
