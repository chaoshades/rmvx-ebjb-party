#==============================================================================
# ** Window_Party_Order
#------------------------------------------------------------------------------
#  This window displays party order
#==============================================================================

class Window_Party_Order < Window_Selectable_Multiple
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array for UCFormationCharFace for the name and face of each member of the party
  attr_reader :ucCharFacesList
  
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
  #     members : party members
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, members)
    super(x, y, width, height, 10, 156 - 32)
    @column_max = 4
    @ucCharFacesList = []

    window_update(members)
    self.index = 0
  end

  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     members : party members
  #--------------------------------------------------------------------------
  def window_update(members)
    @data = []
    for i in @data.size .. 4-1
      @data.push(nil)
    end
    
    if members != nil
      index = 0
      for member in members
        @data[$game_party.actor_positions[index]] = member
        index += 1
      end
    end
    
    @item_max = @data.size
    create_contents()
    @ucCharFacesList.clear()
    for i in 0..@item_max-1
      @ucCharFacesList.push(create_item(i))
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucCharFacesList.each() { |ucCharFace| ucCharFace.draw() }
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for CharFacesList
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    actor = @data[index]
    rect = item_rect(index, true)
    
    ucChar = UCFormationCharFace.new(self, actor, rect)
                                  
    return ucChar
  end
  private :create_item
  
end
