#==============================================================================
# ** Window_SaveFile
#------------------------------------------------------------------------------
#  This window displays save files on the save and load screens.
#==============================================================================

class Window_SaveFile < Window_Base
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw Party Characters
  #     x : Draw spot X coordinate
  #     y : Draw spot Y coordinate
  #--------------------------------------------------------------------------
  def draw_party_characters(x, y)
    for i in 0...@characters.size
      name = @characters[i][0]
      index = @characters[i][1]
      pos = @characters[i][2]
      draw_character(name, index, x + pos * 48, y)
    end
  end
  
end
