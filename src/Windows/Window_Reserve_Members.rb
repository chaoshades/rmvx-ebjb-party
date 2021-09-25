#==============================================================================
# ** Window_Reserve_Members
#------------------------------------------------------------------------------
#  This window displays reserve members
#==============================================================================

class Window_Reserve_Members < Window_Selectable_Multiple
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of UCCharacterGraphic for every reserve member
  attr_reader :ucReserveActorsList
  # Boolean to allow the transfer of the cursor between windows (managed in the Scene)
  attr_reader :cursor_transfer
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get a specific selected reserve actor or current reserve actor
  #     i : index of the selected reserve actor
  #--------------------------------------------------------------------------
  # GET
  def selected_reserve_actor(i=nil)
    actor = nil
    if i == nil
      actor = @data[self.index]
    else
      actor = (index < 0 || self.index(i) < 0 ? nil : @data[self.index(i)])
    end
    return actor
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
  #     actors : actors list
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, actors=nil)
    super(x, y, width, height, 28, 48)
    @column_max = 8
    @ucReserveActorsList = []
    window_update(actors)
    self.index = 0
    @cursor_transfer = false
  end  
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Update
  #     actors : actors list
  #--------------------------------------------------------------------------
  def window_update(actors)
    @data = []
    if actors != nil
      for actor in actors
        if actor != nil
          @data.push(actor)
        end
      end
      # Add a nil one to be able to remove one member from party
      @data.push(nil)
      @item_max = @data.size
      create_contents()
      @ucReserveActorsList.clear()
      for i in 0..@item_max-1
        @ucReserveActorsList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucReserveActorsList.each() { |ucReserveActor| ucReserveActor.draw() }
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    if selected_reserve_actor != nil
      @help_window.window_update(selected_reserve_actor)
      @help_window.visible = true
    else
      @help_window.window_update(nil)
      @help_window.visible = false
    end
  end

  #--------------------------------------------------------------------------
  # * Block selection
  #--------------------------------------------------------------------------
  def block_selection
    result = false
    if selected_reserve_actor != nil
      result = selected_reserve_actor.reserve_locked
    end
    return result
  end
  
  #--------------------------------------------------------------------------
  # * Alias update
  #--------------------------------------------------------------------------
  alias update_ebjb update unless $@
  def update
    @cursor_transfer = false
    last_index = @index
    update_ebjb
    if Input.repeat?(Input::DOWN)
      if @index == last_index
        @cursor_transfer = true
      end
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for ReserveActorsList
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    actor = @data[index]
    rect = item_rect(index)
    
    ucItem = UCCharacterGraphic.new(self, Rect.new(rect.x+9,rect.y+9,30,30), actor,
                                    0, 255, 0, PARTY_CONFIG::CHARS_FACING_DIRECTION)
  
    if actor != nil && actor.reserve_locked
      ucItem.cCharGraphic.opacity = 125
    end
    
    return ucItem
  end
  private :create_item

end
