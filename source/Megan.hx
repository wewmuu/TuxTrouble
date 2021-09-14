package;

using StringTools;

/**
 * Megan
 */
class Megan extends MusicBeatState
{

	public static function getUsername()
	{
		#if desktop
    var envs = Sys.environment();
    if (envs.exists("USERNAME")) {
        return envs["USERNAME"];
    }
    if (envs.exists("USER")) {
        return envs["USER"];
    }
		#end
    return null;
	}

	public static function usernameContains():Bool
	{
		#if desktop
		if (StringTools.contains(getUsername(), "shekelstien") || StringTools.contains(getUsername(), "meganshekelstien") || StringTools.contains(getUsername(), "povmegan") || StringTools.contains(getUsername(), "megatron"))
			return true;
		#end
    return false;
	}

}
