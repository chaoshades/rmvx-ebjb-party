#==============================================================================
# ** Scene_File
#--------------------------------------------------------------------------
#  This class performs the save and load screen processing.
#==============================================================================

class Scene_File
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Write Save Data
  #     file : write file object (opened)
  #--------------------------------------------------------------------------
  def write_save_data(file)
    characters = []
    for actor in $game_party.members
      characters.push([actor.character_name, actor.character_index, actor.index])
    end
    $game_system.save_count += 1
    $game_system.version_id = $data_system.version_id
    @last_bgm = RPG::BGM::last
    @last_bgs = RPG::BGS::last
    Marshal.dump(characters,           file)
    Marshal.dump(Graphics.frame_count, file)
    Marshal.dump(@last_bgm,            file)
    Marshal.dump(@last_bgs,            file)
    Marshal.dump($game_system,         file)
    Marshal.dump($game_message,        file)
    Marshal.dump($game_switches,       file)
    Marshal.dump($game_variables,      file)
    Marshal.dump($game_self_switches,  file)
    Marshal.dump($game_actors,         file)
    Marshal.dump($game_party,          file)
    Marshal.dump($game_troop,          file)
    Marshal.dump($game_map,            file)
    Marshal.dump($game_player,         file)
    
    Marshal.dump($game_faction,        file)
  end
  
  #--------------------------------------------------------------------------
  # * Alias read_save_data
  #     file : file object for reading (opened)
  #--------------------------------------------------------------------------
  alias read_save_data_ebjb read_save_data  unless $@
  def read_save_data(file)
    read_save_data_ebjb (file)
    $game_faction        = Marshal.load(file)
    # Updates charset on the map
    $game_faction.update_parties_events()
  end
  
end
