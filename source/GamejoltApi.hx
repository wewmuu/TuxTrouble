package;

#if (web && USEGAMEJOLT)

//import flixel.util.FlxTimer;
import haxe.Timer;
import openfl.utils.ByteArray;
import flixel.addons.api.FlxGameJolt;
import js.html.URLSearchParams;
import js.Browser;

using StringTools;

@:file("assets/gamejolt.privatekey") class GjPrivateKey extends ByteArrayData {}

class GamejoltApi
{

  // Basic variables needed
  private static var gameUrl:String = ''; // the url of our index, contains user token and username
  private static var gameID:Int = 643473; // our game's ID on GameJolt

  // flags for menus and other shit
  public static var attemptedReauth:Bool = false;
  public static var goodLogin:Bool = false;

  //public static var pingTimer:FlxTimer = new FlxTimer(); // timer we will be using to maintain our session with the gamejolt api.
  public static var pingTimer:Timer; // timer we will be using to maintain our session with the gamejolt api.

  static function gameJoltInitCallback(Result:Bool):Void // callback for FlxGameJolt's init. Add whatever we need here if anything other than the result saving.
  {
    goodLogin = Result;
    if (Result)
    {
      trace('Successfully handshaked with the GameJolt API as ' + FlxGameJolt.username + '!');
      FlxGameJolt.authUser(FlxGameJolt.username, FlxGameJolt.usertoken, authReturn); // authenticate user after init to seal the deal
      FlxGameJolt.openSession(); // open up a session
      FlxGameJolt.pingSession(true, pingReturn);

      /*pingTimer = new FlxTimer().start(5, function(tmr:FlxTimer) // ping the session every 30 seconds
  		{
        trace('Pinging gamejolt');
  			FlxGameJolt.pingSession(true, pingReturn);
  		}, 0);*/

      if (pingTimer != null)
        pingTimer.stop;

      // I'd like to see haxeflixel destroy a normal haxe timer, asshole
      pingTimer = new Timer(30000); // using haxe's timer because the FlxTimer class refuses to fucking persist between states
      pingTimer.run = function() // ping the session every 30 seconds
  		{
        //trace('Pinging gamejolt...');
  			FlxGameJolt.pingSession(true, pingReturn);
  		};

    }
    else
    {
      trace('Handshake failed!?');
    }
  }

  public static function gameJoltInit():Void
  {

    var gjapi_username:String = 'uninitialized'; // our user's GameJolt username
    var gjapi_token:String = 'uninitialized'; // our user's gamejolt token

    // code snippet courtesey of https://github.com/charlesgriffiths/gjCloud
    // we need to get keys ourselves for HTML5 becuase nobody in flixel fucking maintains this peice of shit api interface.
    // It only auto grabs the keys for Flash, which is fucking dead if they haven't noticed.

    var document = Browser.window.document;

    gameUrl = document.URL;

    trace(document.URL);

    if (-1 != gameUrl.indexOf( "index.html?" ))
    {
    var usp = new URLSearchParams( gameUrl.split( "index.html?" )[1] );

      gjapi_username = usp.get( "gjapi_username" );
      gjapi_token = usp.get( "gjapi_token" );
    }

    var gameKey:ByteArray = new GjPrivateKey(); // our GameJolt private key. Only get it when initializing.

    trace('Attempting GameJolt logon as ' + gjapi_username + ' ...');

    FlxGameJolt.init(gameID, gameKey.readUTFBytes(gameKey.length), true, gjapi_username, gjapi_token, gameJoltInitCallback);

  }

  public static function apiGetString(Name:String):String
  {
    var out:String = '';

    switch (Name)
    {
      case "username":
        out = FlxGameJolt.username;
      case "usertoken":
        out = FlxGameJolt.usertoken;
      default:
        trace("Bad/nonexistent call.");
    }

    return out;
  }

  public static function isInitialized():Bool
  {
    return FlxGameJolt.initialized;
  }

  // ease-of-use functions
  // these are mostly just functions that call FlxGameJolt functions to make my life easier

  // Trophies
  public static function addTrophy(trophyNum:Int, ?_callback):Void
  {
    if (_callback != null)
      FlxGameJolt.addTrophy(trophyNum, _callback);
    else
      FlxGameJolt.addTrophy(trophyNum);
  }

  public static function fetchTrophy(DataType:Int = 0, ?_callback):Void
  {
    if (_callback != null)
      FlxGameJolt.fetchTrophy(DataType, _callback);
    else
      FlxGameJolt.fetchTrophy(DataType);
  }

  // Data-cache
  public static function setData(key:String, value:String, setUserData:Bool = true, ?_callback):Void
  {
    if (_callback != null)
      FlxGameJolt.setData(key, value, setUserData, _callback);
    else
      FlxGameJolt.setData(key, value, setUserData);
  }

  public static function fetchData(key:String, fetchUserData:Bool = true, ?_callback):Void
  {
    if (_callback != null)
      FlxGameJolt.fetchData(key, fetchUserData, _callback);
    else
      FlxGameJolt.fetchData(key, fetchUserData);
  }

  public static function fetchAllData(fetchUserData:Bool = true, ?_callback):Void
  {
    if (_callback != null)
      FlxGameJolt.getAllKeys(fetchUserData, _callback);
    else
      FlxGameJolt.getAllKeys(fetchUserData);
  }

  // score
  public static function addScore(Score:String, Sort:Float, ?TableID:Int, AllowGuest:Bool = false, ?GuestName:String, ?ExtraData:String, ?Callback:Dynamic):Void
  {
    FlxGameJolt.addScore(Score, Sort, TableID, AllowGuest, GuestName, ExtraData, Callback);
  }

  // callbacks

  public static function authReturn(Success:Bool):Void
  {
    trace("The user authentication returned: " + Success + ".");

    if (!Success)
    {
      trace("This is probably because the user is already authenticated! You can use resetUser() to authenticate a new user.");
    }
  }

  public static function pingReturn(ReturnMap:Map<String, String>):Void
  {

    //trace('Ping returned ' + ReturnMap['success']);

    if (ReturnMap['success'] != 'true')
    {
      trace("Session expired. Opening new session.");
      pingTimer.stop();
      FlxGameJolt.openSession(openSeshReturn);
    }

  }

  public static function openSeshReturn(ReturnMap:Map<String, String>):Void
  {

    if (ReturnMap['success'] == 'true')
    {
      attemptedReauth = false;

      // I'd like to see haxeflixel destroy a normal haxe timer, asshole
      pingTimer = new Timer(30000); // using haxe's timer because the FlxTimer class refuses to fucking persist between states
      pingTimer.run = function() // ping the session every 30 seconds
      {
        trace('Pinging gamejolt...');
        FlxGameJolt.pingSession(true, pingReturn);
      };

      trace("Re-opened GameJolt API session.");
    }
    else if (!attemptedReauth)
    {
      trace("Opening session failed. Reauthenticating and retrying.");
      pingTimer.stop();

      FlxGameJolt.resetUser(FlxGameJolt.username, FlxGameJolt.usertoken, function(ReturnMap:Map<String, String>){
        FlxGameJolt.authUser(FlxGameJolt.username, FlxGameJolt.usertoken, function(ReturnMap:Map<String, String>){
          attemptedReauth = true;
          FlxGameJolt.openSession(openSeshReturn);
        });
      });

    }

  }

}

#end
