#==============================================================================
# ** UCBattleFormation
#------------------------------------------------------------------------------
#  Represents a group of controls to show a battle formation
#==============================================================================

class UCBattleFormation < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Label for the battle formation name
  attr_reader :cBattleFormationName
  # Array for UCCharacterGraphic for each member of the party
  attr_reader :ucCharGraphicsList
  # Battle Formation object
  attr_reader :battle_formation
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set the visible property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def visible=(visible)
    @visible = visible
    @cBattleFormationName.visible = visible
    @ucCharGraphicsList.each() { |ucCharGraphic| ucCharGraphic.visible = visible }
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @cBattleFormationName.active = active
    @ucCharGraphicsList.each() { |ucCharGraphic| ucCharGraphic.active = active }
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the user control will appear
  #     battle_formation : battle formation object
  #     rect : rectangle to position the controls for the battle formation
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, battle_formation, rect,
                 active=true, visible=true)
    super(active, visible)
    @battle_formation = battle_formation
    
    # Determine rectangles to position controls
    rects = determine_rects(rect)
    
    @cBattleFormationName = CLabel.new(window, rects[0], 
                                       battle_formation.name, 1, Font.bold_font)
    @cBattleFormationName.active = active
    @cBattleFormationName.visible = visible
    
    x_base = rects[1].x
    y_base = rects[1].y
    w_base = rects[1].width / battle_formation.positions.size
    h_base = rects[1].height / battle_formation.positions.size
    @ucCharGraphicsList = []
    
    # Draw the party members in formation
    for i in 0 .. $game_party.members.size-1
      if $game_party.members[i] != nil
        member_pos = $game_party.actor_positions[i]
        x = x_base + battle_formation.positions[member_pos][0] * w_base
        y = y_base + battle_formation.positions[member_pos][1] * h_base
        
        ucCharGraphic = UCCharacterGraphic.new(window, Rect.new(x,y,w_base,h_base), $game_party.members[i],
                                               0, 255, 0, 3)
        @ucCharGraphicsList.push(ucCharGraphic)
      end
    end
    
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the controls
  #--------------------------------------------------------------------------
  def draw()
    @cBattleFormationName.draw()
    @ucCharGraphicsList.each() { |ucCharGraphic| ucCharGraphic.draw() }
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Determine rectangles to positions controls in the user control
  #     rect : base rectangle to position the controls
  #--------------------------------------------------------------------------
  def determine_rects(rect)
    rects = []
    
    # Rects Initialization
    rects[0] = Rect.new(rect.x,rect.y,rect.width,24)
    rects[1] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    
    # Rects Adjustments
    
    # cBattleFormationName
    # Nothing to do
    
    # ucCharGraphic
    rects[1].y += rects[0].height
    rects[1].height -= rects[0].height
    
    return rects
  end
  private :determine_rects
  
end
