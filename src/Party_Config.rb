#==============================================================================
# ** PARTY_CONFIG
#------------------------------------------------------------------------------
#  Contains the Party configuration
#==============================================================================

module EBJB
  
  #==============================================================================
  # ** Battle_Formation
  #------------------------------------------------------------------------------
  #  Represents a battle formation
  #==============================================================================

  class Battle_Formation
    
    #//////////////////////////////////////////////////////////////////////////
    # * Attributes
    #//////////////////////////////////////////////////////////////////////////
    
#~     # Name of the battle formation
#~     attr_reader :name
#~     # Description of the battle formation
#~     attr_reader :description
    # Array of positions that describes the battle formation
    attr_reader :positions
    # Array of bonuses of the battle formation
    attr_reader :bonuses
    
    #//////////////////////////////////////////////////////////////////////////
    # * Properties
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Get the name of the battle formation
    #--------------------------------------------------------------------------
    def name()
      return Vocab::battle_formations_strings[@v_index][0]
    end
    
    #--------------------------------------------------------------------------
    # * Get the description of the battle formation
    #--------------------------------------------------------------------------
    def description()
      return Vocab::battle_formations_strings[@v_index][0]
    end
    
    #//////////////////////////////////////////////////////////////////////////
    # * Constructors
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     v_index : index in the Vocab to get name and description of the battle formation
    #     positions : array of positions that describes the battle formation
    #     bonuses : array of bonuses of the battle formation
    #--------------------------------------------------------------------------
    def initialize(v_index, positions, bonuses)
      @v_index = v_index
#~       @name = Vocab::battle_formations_strings[v_index][0]
#~       @description = Vocab::battle_formations_strings[v_index][1]
      @positions = positions
      @bonuses = bonuses
    end
    
  end
  
  module PARTY_CONFIG
    
    # Background image filename, it must be in folder Pictures
    IMAGE_BG = ""
    # Opacity for background image
    IMAGE_BG_OPACITY = 255
    # All windows opacity
    WINDOW_OPACITY = 255
    WINDOW_BACK_OPACITY = 200
    
    #------------------------------------------------------------------------
    # Generic patterns
    #------------------------------------------------------------------------
    
    # Gauge pattern
    GAUGE_PATTERN = "%d/%d"
    # Percentage pattern
    PERCENTAGE_PATTERN = "%d%"
    # Max EXP gauge value
    MAX_EXP_GAUGE_VALUE = "-------/-------"   
    
    #------------------------------------------------------------------------
    # Multiple Parties feature related
    #------------------------------------------------------------------------
    
    # True to have the same items between parties, else false
    MERGE_ITEMS = true
    # True to have the same weapons between parties, else false
    MERGE_WEAPONS = true
    # True to have the same armors between parties, else false
    MERGE_ARMORS = true
    # True to have the same gold between parties, else false
    MERGE_GOLD = true
    # True to have the same steps between parties, else false
    MERGE_STEPS = true
    
    #------------------------------------------------------------------------
    # Scene Party related
    #------------------------------------------------------------------------
    
    # Direction where the characters are facing in the Party Change window
    #   0 - Bottom
    #   1 - Left
    #   2 - Right
    #   3 - Top
    CHARS_FACING_DIRECTION = 1
    
    #------------------------------------------------------------------------
    # Member Info Window related
    #------------------------------------------------------------------------

    # Number of icons to show at the same time
    ACT_STATES_MAX_ICONS = 4
    # Timeout in seconds before switching icons
    ACT_STATES_ICONS_TIMEOUT = 1
    
    # Icon for EXP
    ICON_EXP  = 102
    # Icon for Level
    ICON_LVL  = 132
    
    # Icon for HP
    ICON_HP  = 99
    # Icon for MP
    ICON_MP  = 100
    
    #------------------------------------------------------------------------
    # Scene Formation related
    #------------------------------------------------------------------------
       
    # Unique ids used to represent battle formation lines
    FRONT_LINE = 0
    MIDDLE_LINE = 1
    BACK_LINE = 2
    
    # Unique ids used to represent battle formation bonuses
    # STATS = 10xx
    BF_BONUS_ATK = 1001
    BF_BONUS_DEF = 1002
    BF_BONUS_SPI = 1003
    BF_BONUS_AGI = 1004
    BF_BONUS_EVA = 1005
    BF_BONUS_HIT = 1006
    BF_BONUS_CRI = 1007
    
    # Battle formations definitions
    
    # Battle formations array
    BATTLE_FORMATIONS = [
      # First battle formation - Normal
      Battle_Formation.new(0, 
                           [[0,MIDDLE_LINE], [1,MIDDLE_LINE], [2,MIDDLE_LINE], [3,MIDDLE_LINE]],
                           {}),
      # Second battle formation - Corner
      Battle_Formation.new(1, 
                           [[0,MIDDLE_LINE], [0,BACK_LINE], [1,MIDDLE_LINE], [1,BACK_LINE]],
                           {BF_BONUS_DEF => 125, 
                           BF_BONUS_ATK => 75}),
      # Third battle formation - Arrow
      Battle_Formation.new(2, 
                           [[1,FRONT_LINE], [0,MIDDLE_LINE], [2,MIDDLE_LINE], [1,BACK_LINE]],
                           {BF_BONUS_CRI => 110, 
                            BF_BONUS_ATK => 125}),
      # Fourth battle formation - Parallel
      Battle_Formation.new(3, 
                           [[0,MIDDLE_LINE], [0,BACK_LINE], [1,MIDDLE_LINE], [1,BACK_LINE]],
                           {BF_BONUS_EVA => 125})
    ]
    
    # Formation lines definitions
    
    # Formation lines hash
    FORMATION_LINES = {
        FRONT_LINE => {BF_BONUS_CRI => 105, 
                       BF_BONUS_ATK => 110,
                       BF_BONUS_DEF => 90},
        MIDDLE_LINE => {},
        BACK_LINE => {BF_BONUS_ATK => 90,
                      BF_BONUS_DEF => 110}
    }
    
    #------------------------------------------------------------------------
    # Battle Formation Details Window related
    #------------------------------------------------------------------------
    
    # Symbol when a stat is higher with the new item
    POWERUP_SYMBOL = "+" #"▲"
    # Symbol when a stat is lower with the new item
    POWERDOWN_SYMBOL = "-" #"▼"

  end
end
