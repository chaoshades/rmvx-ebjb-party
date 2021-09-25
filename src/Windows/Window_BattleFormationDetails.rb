#==============================================================================
# ** Window_BattleFormationDetails
#------------------------------------------------------------------------------
#  This window shows the details of a battle formation
#==============================================================================

class Window_BattleFormationDetails < Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCLabelIcon for the battle formation name
  attr_reader :cBattleFormationLabel
  # CLabel for Stats
  attr_reader :cStatsLabel
  # UCLabelValue for the ATK stat of the item
  attr_reader :ucAtkStat
  # UCLabelValue for the DEF stat of the item
  attr_reader :ucDefStat
  # UCLabelValue for the SPI stat of the item
  attr_reader :ucSpiStat
  # UCLabelValue for the AGI stat of the item
  attr_reader :ucAgiStat
  # UCLabelValue for the HIT stat of the item
  attr_reader :ucHitStat
  # UCLabelValue for the EVA stat of the item
  attr_reader :ucEvaStat
  # UCLabelValue for the CRI stat of the item
  attr_reader :ucCriStat
#~   # Icons list for the bonuses of the item
#~   attr_reader :ucBonusesStat
#~   # Icons list for the elements of the item
#~   attr_reader :ucElementsStat
#~   # CLabel for States
#~   attr_reader :cStatesLabel
#~   # Icons list for the states of the item
#~   attr_reader :ucStatesStat
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #     width : window width
  #     height : window height
  #     formation : battle formation object
  #     spacing : spacing between stats
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, formation, spacing = 10)
    super(x, y, width, height)

    @cBattleFormationLabel = CLabel.new(self, Rect.new(0,0,212,WLH), "")
    
    @cStatsLabel = CLabel.new(self, Rect.new(0,40,80,WLH), Vocab::stats_label)
        
    @ucAtkStat = UCLabelValue.new(self, Rect.new(80+spacing,34,30,WLH), 
                                  Rect.new(110+spacing,34,48,WLH), Vocab::atk_label, 0)
    @ucAtkStat.cLabel.font = Font.formation_details_stats_font
    @ucAtkStat.cValue.font = Font.formation_details_stats_font
    @ucDefStat = UCLabelValue.new(self, Rect.new(80+spacing,46,30,WLH), 
                                  Rect.new(110+spacing,46,48,WLH), Vocab::def_label, 0)
    @ucDefStat.cLabel.font = Font.formation_details_stats_font
    @ucDefStat.cValue.font = Font.formation_details_stats_font
    
    @ucSpiStat = UCLabelValue.new(self, Rect.new(158+spacing*2,34,30,WLH), 
                                  Rect.new(188+spacing*2,34,48,WLH), Vocab::spi_label, 0)
    @ucSpiStat.cLabel.font = Font.formation_details_stats_font
    @ucSpiStat.cValue.font = Font.formation_details_stats_font
    @ucAgiStat = UCLabelValue.new(self, Rect.new(158+spacing*2,46,30,WLH), 
                                  Rect.new(188+spacing*2,46,48,WLH), Vocab::agi_label, 0)
    @ucAgiStat.cLabel.font = Font.formation_details_stats_font
    @ucAgiStat.cValue.font = Font.formation_details_stats_font
    
    @ucHitStat = UCLabelValue.new(self, Rect.new(236 + spacing*3,34,30,WLH), 
                                  Rect.new(266 + spacing*3,34,48,WLH), Vocab::hit_label, 0)
    @ucHitStat.cLabel.font = Font.formation_details_stats_font
    @ucHitStat.cValue.font = Font.formation_details_stats_font
    @ucEvaStat = UCLabelValue.new(self, Rect.new(236 + spacing*3,46,30,WLH), 
                                  Rect.new(266 + spacing*3,46,48,WLH), Vocab::eva_label, 0)
    @ucEvaStat.cLabel.font = Font.formation_details_stats_font
    @ucEvaStat.cValue.font = Font.formation_details_stats_font
    
    @ucCriStat = UCLabelValue.new(self, Rect.new(314 + spacing*4,34,30,WLH), 
                                  Rect.new(344 + spacing*4,34,48,WLH), Vocab::cri_label, 0)
    @ucCriStat.cLabel.font = Font.formation_details_stats_font
    @ucCriStat.cValue.font = Font.formation_details_stats_font
    
#~     @ucBonusesStat = UCLabelIconsList.new(self, Rect.new(430,40,80,WLH),
#~                                         Rect.new(510,40,100,WLH), MENU_CONFIG::BONUS_LABEL, [0])

#~     @ucElementsStat = UCLabelIconsSwitchableList.new(self, Rect.new(236,0,80,WLH),
#~                                          Rect.new(326,0,100,WLH), MENU_CONFIG::ELEMENTS_LABEL, [0],
#~                                          MENU_CONFIG::SW_LIST_MAX_ICONS, MENU_CONFIG::SW_LIST_ICONS_TIMEOUT)
#~     @cStatesLabel = CLabel.new(self, Rect.new(430,0,80,WLH), MENU_CONFIG::STATES_LABEL)
#~     @ucStatesStat = UCLabelIconControlsSwitchableList.new(self, Rect.new(510,0,50,WLH), [],
#~                                          MENU_CONFIG::SW_LIST_MAX_ICONS, MENU_CONFIG::SW_LIST_ICONS_TIMEOUT)

    window_update(formation)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     item : item object
  #--------------------------------------------------------------------------
  def window_update(formation)
    if formation != nil
      @cBattleFormationLabel.text = formation.name

      set_bonus_rate_value(@ucAtkStat.cValue, formation.bonuses[PARTY_CONFIG::BF_BONUS_ATK])
      set_bonus_rate_value(@ucDefStat.cValue, formation.bonuses[PARTY_CONFIG::BF_BONUS_DEF])
      set_bonus_rate_value(@ucSpiStat.cValue, formation.bonuses[PARTY_CONFIG::BF_BONUS_SPI])
      set_bonus_rate_value(@ucAgiStat.cValue, formation.bonuses[PARTY_CONFIG::BF_BONUS_AGI])
      set_bonus_rate_value(@ucHitStat.cValue, formation.bonuses[PARTY_CONFIG::BF_BONUS_HIT])
      set_bonus_rate_value(@ucEvaStat.cValue, formation.bonuses[PARTY_CONFIG::BF_BONUS_EVA])
      set_bonus_rate_value(@ucCriStat.cValue, formation.bonuses[PARTY_CONFIG::BF_BONUS_CRI])

#~       iconsArray = []
#~       if item.is_a?(RPG::Weapon)
#~         iconsArray.push(MENU_CONFIG::BONUS_ICONS[0]) if item.two_handed
#~         iconsArray.push(MENU_CONFIG::BONUS_ICONS[1]) if item.critical_bonus
#~       else
#~         iconsArray.push(MENU_CONFIG::BONUS_ICONS[2]) if item.prevent_critical 
#~         iconsArray.push(MENU_CONFIG::BONUS_ICONS[3]) if item.half_mp_cost
#~       end
#~       @ucBonusesStat.icons = iconsArray

#~       iconsArray = []
#~       for i in 0 .. item.element_set.size-1
#~         iconsArray[i] = MENU_CONFIG::ELEMENT_ICONS[item.element_set[i]]
#~       end
#~       @ucElementsStat.icons = iconsArray

#~       controlsArray = []
#~       baseX = @ucStatesStat.rectControls.x
#~       for i in 0 .. item.state_set.size-1
#~         temp = UCLabelIcon.new(self, Rect.new(baseX,-6,24,24), Rect.new(baseX,0,24,24), 
#~                                nil, $data_states[item.state_set[i]].icon_index)

#~         if item.is_a?(RPG::Weapon)
#~           temp.cLabel.text =  MENU_CONFIG::STATES_PLUS_SIGN
#~           temp.cLabel.font = Font.item_details_plus_states_font
#~         else
#~           temp.cLabel.text =  MENU_CONFIG::STATES_MINUS_SIGN
#~           temp.cLabel.font = Font.item_details_minus_states_font
#~         end
#~         controlsArray.push(temp)
#~       end
#~       @ucStatesStat.controls = controlsArray
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @cBattleFormationLabel.draw()
    @cStatsLabel.draw()
    @ucAtkStat.draw()
    @ucDefStat.draw()
    @ucSpiStat.draw()
    @ucAgiStat.draw()
    @ucHitStat.draw()
    @ucEvaStat.draw()
    @ucCriStat.draw()
#~     @ucBonusesStat.draw()
#~     @ucElementsStat.draw()
#~     @cStatesLabel.draw()
#~     @ucStatesStat.draw()
  end
  
#~   #--------------------------------------------------------------------------
#~   # * Frame Update (for the icons list that refreshed after a timeout)
#~   #--------------------------------------------------------------------------
#~   def update
#~     super
#~     @ucElementsStat.update()
#~     @ucStatesStat.update()
#~   end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Update the bonus rate value in the control
  #     control : control to set the value
  #     rate : bonus rate
  #--------------------------------------------------------------------------
  def set_bonus_rate_value(control, rate)
    if rate != nil
      # Adjusts rate (ex.: 75% will show -25%)
      rate = rate - 100
      if rate >= 0
        control.font.color = Color.power_up_color
        control.text = PARTY_CONFIG::POWERUP_SYMBOL + sprintf(PARTY_CONFIG::PERCENTAGE_PATTERN, rate.abs.to_s)
      else
        control.font.color = Color.power_down_color
        control.text = PARTY_CONFIG::POWERDOWN_SYMBOL + sprintf(PARTY_CONFIG::PERCENTAGE_PATTERN, rate.abs.to_s)
      end
    else
      control.font.color = Color.normal_color
      control.text = sprintf(PARTY_CONFIG::PERCENTAGE_PATTERN, "0")
    end
  end
  private :set_bonus_rate_value

end
