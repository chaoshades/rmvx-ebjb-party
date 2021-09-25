#===============================================================================
# ** Window_Battle_Formations
#------------------------------------------------------------------------------
#  This window displays battle formations in the Formation screen
#===============================================================================

class Window_Battle_Formations < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of battle formations
  attr_reader :formationsList
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current battle formation
  #--------------------------------------------------------------------------
  # GET
  def selected_formation
    return @data[self.index]
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window x-coordinate
  #     y : window y-coordinate
  #     width : window width
  #     height : window height
  #     formations : battle formations list
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, formations)
    super(x, y, width, height, 32, 98)
    @column_max = 3
    @formationsList = []
    window_update(formations)
    self.index = 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     formations : battle formations list
  #--------------------------------------------------------------------------
  def window_update(formations)
    @data = []   
    if formations != nil
      for formation in formations
        if formation != nil
          @data.push(formation)
        end
      end
      @item_max = @data.size
      create_contents()
      @formationsList.clear()
      for i in 0..@item_max-1
        @formationsList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @formationsList.each() { |formation| formation.draw() }
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    if selected_formation != nil
      @help_window.window_update(selected_formation.description)
    else
      @help_window.window_update("")
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update Detail Window
  #--------------------------------------------------------------------------
  def update_detail
    if selected_formation != nil
      @detail_window.window_update(selected_formation)
    else
      @detail_window.window_update(nil)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Determine if help/detail window can be switched
  #--------------------------------------------------------------------------
  def is_switchable
    return selected_formation != nil && selected_formation.is_a?(Battle_Formation)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for the formations list
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    formation = @data[index]
    rect = item_rect(index, true)
    
    formationItem = UCBattleFormation.new(self, formation, rect)

    return formationItem
  end
  private :create_item
  
end
