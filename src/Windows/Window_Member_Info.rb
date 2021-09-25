#==============================================================================
# ** Window_Member_Info
#------------------------------------------------------------------------------
#  This window displays party member basic information on the party change screen
#==============================================================================

class Window_Member_Info < Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCCharacterFace for the character's face
  attr_reader :ucCharFace
  # Label for the character name
  attr_reader :cCharName
  # Icons list for the actives states of the character
  attr_reader :ucActStates
  # UCLabelIconValue for the character's level
  attr_reader :ucCharLvl
  # UCLabelIconValue for the character's HP
  attr_reader :ucHpStat
  # UCBar for the HP gauge of the character
  attr_reader :ucHpStatGauge
  # UCLabelIconValue for the character's MP
  attr_reader :ucMpStat
  # UCBar for the MP gauge of the character
  attr_reader :ucMpStatGauge
  # UCLabelIconValue for the character's experience
  attr_reader :ucExp
  # UCBar for the EXP gauge of the character
  attr_reader :ucExpGauge
    
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #     width : window width
  #     height : window height
  #     actor : actor object
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, actor)
    super(x, y, width, height)
                         
    @ucCharFace = UCCharacterFace.new(self, Rect.new(0,0,96,96), nil)

    @cCharName = CLabel.new(self, Rect.new(105,24,200,WLH), "")
    @cCharName.font = Font.bold_font
    
    @ucActStates = UCLabelIconsSwitchableList.new(self, nil,
                         Rect.new(105, 48, 200, WLH), 
                         "", [0], PARTY_CONFIG::ACT_STATES_MAX_ICONS, 
                         PARTY_CONFIG::ACT_STATES_ICONS_TIMEOUT) 
    
    rectLvl = Rect.new(310,0,50,WLH)
    @ucCharLvl = UCLabelIconValue.new(self, rectLvl, 
                                     Rect.new(rectLvl.x-24,rectLvl.y,24,24), 
                                     Rect.new(rectLvl.x+rectLvl.width,rectLvl.y,
                                              85, rectLvl.height), 
                                     Vocab::lvl_label, 
                                     PARTY_CONFIG::ICON_LVL, "")
    @ucCharLvl.cValue.align = 2
    
    rectHp = Rect.new(310,24,25,WLH)
    @ucHpStat = UCLabelIconValue.new(self, rectHp, 
                                     Rect.new(rectHp.x-24,rectHp.y,24,24), 
                                     Rect.new(rectHp.x+rectHp.width, rectHp.y,
                                              110, rectHp.height), 
                                     Vocab::hp_label, 
                                     PARTY_CONFIG::ICON_HP, "")
    @ucHpStat.cValue.align = 2
    
    @ucHpStatGauge = UCBar.new(self, Rect.new(rectHp.x-24, rectHp.y+16,
                                              rectHp.width+24+110+2, rectHp.height-16), 
                              Color.hp_gauge_color1, Color.hp_gauge_color2, Color.gauge_back_color, 
                              0, 0, 1, Color.gauge_border_color)

    rectMp = Rect.new(310,48,25,WLH)
    @ucMpStat = UCLabelIconValue.new(self, rectMp, 
                                     Rect.new(rectMp.x-24,rectMp.y,24,24), 
                                     Rect.new(rectMp.x+rectMp.width, rectMp.y,
                                              110, rectMp.height),  
                                     Vocab::mp_label, 
                                     PARTY_CONFIG::ICON_MP, "")
    @ucMpStat.cValue.align = 2
    
    @cMpStatGauge = UCBar.new(self, Rect.new(rectMp.x-24, rectMp.y+16,
                                             rectMp.width+24+110+2, rectMp.height-16),  
                              Color.mp_gauge_color1, Color.mp_gauge_color2, Color.gauge_back_color, 
                              0, 0, 1, Color.gauge_border_color)                    
  
    rectExp = Rect.new(310,72,25,WLH)
    @ucExp = UCLabelIconValue.new(self, rectExp, 
                                  Rect.new(rectExp.x-24,rectExp.y,24,24), 
                                  Rect.new(rectExp.x+rectExp.width, rectExp.y,
                                           110, rectExp.height),
                                  Vocab::exp_label, 
                                  PARTY_CONFIG::ICON_EXP, "")
    @ucExp.cValue.align = 2
    @ucExpGauge = UCBar.new(self, Rect.new(rectExp.x-24, rectExp.y+16,
                                           rectExp.width+24+110+2, rectExp.height-16), 
                              Color.exp_gauge_color1, Color.exp_gauge_color2, Color.gauge_back_color, 
                              0, 0, 1, Color.gauge_border_color)                    

    window_update(actor)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Update
  #     actor : actor object
  #--------------------------------------------------------------------------
  def window_update(actor)
    if actor != nil
      @ucCharFace.actor = actor
      
      iconsArray = []
      for i in 0 .. actor.states.size-1
        iconsArray[i] = actor.states[i].icon_index
      end
      @ucActStates.icons = iconsArray
      
      @cCharName.text = actor.name
      @ucCharLvl.cValue.text = actor.level
      
      @ucHpStat.cValue.text = sprintf(PARTY_CONFIG::GAUGE_PATTERN, actor.hp, actor.maxhp)
      @ucHpStatGauge.value = actor.hp
      @ucHpStatGauge.max_value = actor.maxhp
      
      if actor.hp == 0
        @ucHpStat.cValue.font.color = Color.knockout_color
      elsif actor.hp < actor.maxhp / 4
        @ucHpStat.cValue.font.color = Color.crisis_color
      else
        @ucHpStat.cValue.font.color = Color.normal_color
      end
      
      @ucMpStat.cValue.text = sprintf(PARTY_CONFIG::GAUGE_PATTERN, actor.mp, actor.maxmp)
      @cMpStatGauge.value = actor.mp
      @cMpStatGauge.max_value = actor.maxmp
      
      if actor.mp < actor.maxmp / 4
        @ucMpStat.cValue.font.color = Color.crisis_color
      else
        @ucMpStat.cValue.font.color = Color.normal_color
      end
      
      if (actor.next_exp == 0)
        gauge_min = 1
        gauge_max = 1
        exp_value = PARTY_CONFIG::MAX_EXP_GAUGE_VALUE
      else
        gauge_min = actor.now_exp
        gauge_max = actor.next_exp
        exp_value = sprintf(PARTY_CONFIG::GAUGE_PATTERN, actor.now_exp, actor.next_exp)
      end
      
      @ucExp.cValue.text = exp_value
      @ucExpGauge.value = gauge_min
      @ucExpGauge.max_value = gauge_max
      
    end
    refresh()
  end

  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucCharFace.draw()
    @cCharName.draw()
    @ucCharLvl.draw()
    @ucHpStatGauge.draw()
    @ucHpStat.draw()
    @cMpStatGauge.draw()
    @ucMpStat.draw()
    @ucExpGauge.draw()
    @ucExp.draw()
  end
  
  #--------------------------------------------------------------------------
  # * Frame Update (for the icons list that refreshed after a timeout)
  #--------------------------------------------------------------------------
  def update
    super
    @ucActStates.update()
  end
  
end
