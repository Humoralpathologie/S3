package engine
{
  import flash.media.Sound;
  import flash.media.SoundTransform;
  import flash.media.SoundChannel;
  import flash.events.Event;
  import com.gskinner.motion.GTween;
  import starling.core.Starling;
  
  /**
   * ...
   * @author
   */
  public class SoundManager
  {
    
    private var _sounds:Object;
    private var _musicPlaying:Array;
    private var _soundsPlaying:Array;
    private var _musicTransform:SoundTransform;
    private var _soundTransform:SoundTransform;
    private var _level:int = 0;
    private const PLAYING:int = 1;
    private const FADING:int = 2;
    private const STOPPED:int = 3;
    private var STATE:int = STOPPED;
    
    public function SoundManager()
    {
      _sounds = {};
      _musicPlaying = [];
      _soundsPlaying = [];
      _musicTransform = new SoundTransform();
      _soundTransform = new SoundTransform();
    }
    
    public function registerSound(name:String, sound:Sound):void
    {
      _sounds[name] = sound;
    }
    
    public function fadeOutMusic(delay:Number = 2):void
    {
      var tween:GTween = new GTween(_musicTransform, delay, {volume: 0}, {onComplete: clearMusic, onChange: updateChannels});
    }
    
    private function updateChannels(t:GTween):void
    {
      for (var i:int = 0; i < _musicPlaying.length; i++)
      {
        var channel:SoundChannel = _musicPlaying[i];
        if (channel)
        {
          channel.soundTransform = _musicTransform;
        }
      }
    }
    
    private function clearMusic(t:GTween):void
    {
      var music:SoundChannel;
      while (music = _musicPlaying.pop())
      {
        music.stop();
      }
      _musicTransform.volume = 1;
    }
    
    public function playMusic(name:String):void
    {
      var music:Sound = _sounds[name];
      if (music)
      {
        var channel:SoundChannel;
        channel = music.play(0, 1, _musicTransform);
        _musicPlaying.push(channel);
        channel.addEventListener(Event.SOUND_COMPLETE, function(event:Event):void
          {
            _musicPlaying.splice(_musicPlaying.indexOf(channel), 1);
          });
      }
    }
    
    public function levelMusic():void
    {
      var musicLevels:Array = [AssetRegistry.LevelMusic1Sound, AssetRegistry.LevelMusic2Sound, AssetRegistry.LevelMusic3Sound, AssetRegistry.LevelMusic4Sound];
      if (STATE == STOPPED)
      {
        var music:Sound; 
        var channel:SoundChannel;
        STATE = PLAYING;
        var play:Function = function():void
        {
          trace("Playing music level");
          trace(_level);
          music = musicLevels[Math.min(_level, musicLevels.length - 1)];
          channel = music.play(0, 1, _musicTransform);
          _musicPlaying.push(channel);
          channel.addEventListener(Event.SOUND_COMPLETE, function(event:Event):void
            {
              _musicPlaying.splice(_musicPlaying.indexOf(channel), 1);
              play();
            });
        }
        play();
      }
    }
    
    public function playSound(name:String):void
    {
      var sound:Sound = _sounds[name];
      if (sound)
      {
        var channel:SoundChannel;
        channel = sound.play(0, 1, _soundTransform);
        _soundsPlaying.push(channel);
        channel.addEventListener(Event.SOUND_COMPLETE, function(event:Event):void
          {
            _soundsPlaying.splice(_soundsPlaying.indexOf(channel), 1);
          });
        
      }
    }
    
    public function get level():int 
    {
        return _level;
    }
    
    public function set level(value:int):void 
    {
        _level = value;
    }
  }

}