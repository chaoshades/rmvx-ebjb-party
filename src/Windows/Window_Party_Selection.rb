#==============================================================================
# ** Window_Party_Selection
#------------------------------------------------------------------------------
#  This window displays party members
#==============================================================================

class Window_Party_Selection < Window_Selectable_Multiple
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of UCCharacterGraphic for every party member
  attr_reader :ucPartyActorsList
  # Boolean to allow the transfer of the cursor between windows (managed in the Scene)
  attr_reader :cursor_transfer
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get a specific selected actor or current actor
  #     i : index of the selected actor
  #--------------------------------------------------------------------------
  # GET
  def selected_actor(i=nil)
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
  #     party_id : ID of the party
  #     actors : actors list
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, party_id, actors=nil)
    super(x, y, width, height, 28, 48)
    @column_max = 2
    @ucPartyActorsList = []
    @party_id = party_id
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
    for i in @data.size .. 4-1
      @data.push(nil)
    end
    
    if actors != nil
      for actor in actors
        @data[actor.index(@party_id)] = actor
      end
    end
    
    @item_max = @data.size
    create_contents()
    @ucPartyActorsList.clear()
    for i in 0..@item_max-1
      @ucPartyActorsList.push(create_item(i))
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucPartyActorsList.each() { |ucPartyActor| ucPartyActor.draw() }
  end
  
  #--------------------------------------------------------------------------
  # * Return party members of the party index
  #     party_index : party index
  #-------------------------------------------------------------------------- 
  def party_members(party_index)
    actors = []
    for ucPartyActor in @ucPartyActorsList
      actors.push(ucPartyActor.actor)
    end
    return actors
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    if selected_actor != nil
      @help_window.window_update(selected_actor)
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
    if selected_actor != nil
      result = selected_actor.party_locked
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
    if Input.repeat?(Input::RIGHT) && (last_index %= @column_max) > 0
      @cursor_transfer = true
    elsif Input.repeat?(Input::LEFT) && (last_index %= @column_max) == 0
      @cursor_transfer = true
    else
      update_ebjb
    end
    
    if Input.repeat?(Input::UP) 
      if @index == last_index
        @cursor_transfer = true
      end
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for PartyActorsList
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    actor = @data[index]
    rect = item_rect(index)
    
    ucItem = UCCharacterGraphic.new(self, Rect.new(rect.x+9,rect.y+9,30,30), actor,
                                    0, 255, 0, PARTY_CONFIG::CHARS_FACING_DIRECTION)
    
    if actor != nil && actor.party_locked
      ucItem.cCharGraphic.opacity = 125
    end
                                      
    return ucItem
  end
  private :create_item
  
end
