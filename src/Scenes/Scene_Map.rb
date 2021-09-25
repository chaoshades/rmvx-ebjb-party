#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs the map screen processing.
#==============================================================================

class Scene_Map < Scene_Base
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias update_call_menu
  #--------------------------------------------------------------------------
  alias update_call_menu_ebjb update_call_menu unless $@
  def update_call_menu
    update_call_menu_ebjb
    if $game_faction.nbr_active_parties > 1
      if Input.trigger?(Input::R)
        Sound.play_cursor
        fadeout(30)
        $game_faction.next_party()
        party_transition()
        fadein(30)
      elsif Input.trigger?(Input::L)
        Sound.play_cursor
        fadeout(30)
        $game_faction.prev_party()
        party_transition()
        fadein(30)
      end
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Do the transition with the new party
  #--------------------------------------------------------------------------
  def party_transition()
    # Teleports to the party location
    $game_player.reserve_transfer($game_party.map_id, $game_party.player_x, 
                                  $game_party.player_y, $game_party.player_direction)
    update_transfer_player()
  end
  private :party_transition
  
end
