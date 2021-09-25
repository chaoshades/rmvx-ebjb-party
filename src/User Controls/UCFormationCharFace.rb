#==============================================================================
# ** UCFormationCharFace
#------------------------------------------------------------------------------
#  Represents a group of controls to show the character face in the 
#  battle formation menu
#==============================================================================

class UCFormationCharFace < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Label for the character's name
  attr_reader :cCharName
  # UCCharacterFace for the character's face
  attr_reader :ucCharFace
  # Actor object
  attr_reader :actor
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set the visible property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def visible=(visible)
    @visible = visible
    @cCharName.visible = visible
    @ucCharFace.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @cCharName.active = active
    @ucCharFace.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the user control will appear
  #     actor : actor object
  #     rect : rectangle to position the controls for the actor
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, actor, rect,
                 active=true, visible=true)
    super(active, visible)
    @actor = actor
    
    name = ""
    if actor != nil 
      name = actor.name
    end
    
    # Determine rectangles to position controls
    rects = determine_rects(rect)
    
    @cCharName = CLabel.new(window, rects[0], name, 1, Font.bold_font)
    @cCharName.active = active
    @cCharName.visible = visible

    @ucCharFace = UCCharacterFace.new(window, rects[1], actor)
    @ucCharFace.active = active
    @ucCharFace.visible = visible
      
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the controls
  #--------------------------------------------------------------------------
  def draw()
    @cCharName.draw()
    @ucCharFace.draw()
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
    rects[1] = Rect.new(rect.x,rect.y,96,96)
    
    # Rects Adjustments
    
    # cCharName
    # Nothing to do
    
    # ucCharFace
    rects[1].x += ((rect.width - rects[0].width) / 2).floor
    rects[1].y += rects[0].height
    
    return rects
  end
  private :determine_rects
  
end
