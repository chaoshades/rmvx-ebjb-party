#==============================================================================
# ** Window_MenuStatus
#------------------------------------------------------------------------------
#  This window displays party member status on the menu screen.
#==============================================================================

class Window_MenuStatus < Window_Selectable
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update cursor
  #--------------------------------------------------------------------------
  def update_cursor
    if @index < 0               # No cursor
      self.cursor_rect.empty
    elsif @index < @item_max    # Normal
      self.cursor_rect.set(0, $game_party.actor_positions[@index] * 96, contents.width, 96)
    elsif @index >= 100         # Self
      self.cursor_rect.set(0, (@index - 100) * 96, contents.width, 96)
    else                        # All
      self.cursor_rect.set(0, 0, contents.width, @item_max * 96)
    end
  end
  
end
