#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It's used within the Game_Actors class
# ($game_actors) and referenced by the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Indicates if the actor is locked in a party
  attr_accessor :party_locked
  # Indicates if the actor is locked in the reserve
  attr_accessor :reserve_locked
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # Get Now Exp - The experience gained for the current level.
  #--------------------------------------------------------------------------
  # GET
  def now_exp
    return @exp - @exp_list[@level]
  end
  
  #--------------------------------------------------------------------------
  # Get Next Exp - The experience needed for the next level.
  #--------------------------------------------------------------------------
  # GET
  def next_exp
    return @exp_list[@level+1] > 0 ? @exp_list[@level+1] - @exp_list[@level] : 0
  end
  
  #--------------------------------------------------------------------------
  # * Get Actor Index in party
  #     party_id : id of the party in which to get the actor index
  #--------------------------------------------------------------------------
  # GET
  def index(party_id=nil)
    temp = nil
    if party_id == nil
      temp = $game_party.index(self.id)
    else
      temp = $game_faction.game_parties[party_id].index(self.id)
    end
    return temp
  end
  
  #--------------------------------------------------------------------------
  # * Get Basic Attack
  #--------------------------------------------------------------------------
  # GET
  def base_atk
    n = actor.parameters[2, @level]
    # Adds bonus for the battle formation
    if $game_temp.in_battle
      n *= calc_formation_bonus_rate(PARTY_CONFIG::BF_BONUS_ATK) / 100.0
    end
    for item in equips.compact do n += item.atk end
    return n
  end
  
  #--------------------------------------------------------------------------
  # * Get Basic Defense
  #--------------------------------------------------------------------------
  # GET
  def base_def
    n = actor.parameters[3, @level]
    # Adds bonus for the battle formation
    if $game_temp.in_battle
      n *= calc_formation_bonus_rate(PARTY_CONFIG::BF_BONUS_DEF) / 100.0
    end
    for item in equips.compact do n += item.def end
    return n
  end
  
  #--------------------------------------------------------------------------
  # * Get Basic Spirit
  #--------------------------------------------------------------------------
  # GET
  def base_spi 
    n = actor.parameters[4, @level]
    # Adds bonus for the battle formation
    if $game_temp.in_battle
      n *= calc_formation_bonus_rate(PARTY_CONFIG::BF_BONUS_SPI) / 100.0
    end
    for item in equips.compact do n += item.spi end
    return n
  end
  
  #--------------------------------------------------------------------------
  # * Get Basic Agility
  #--------------------------------------------------------------------------
  # GET
  def base_agi
    n = actor.parameters[5, @level]
    # Adds bonus for the battle formation
    if $game_temp.in_battle
      n *= calc_formation_bonus_rate(PARTY_CONFIG::BF_BONUS_AGI) / 100.0
    end
    for item in equips.compact do n += item.agi end
    return n
  end
  
  #--------------------------------------------------------------------------
  # * Get Hit Rate
  #--------------------------------------------------------------------------
  # GET
  def hit
    if two_swords_style
      n1 = weapons[0] == nil ? 95 : weapons[0].hit
      n2 = weapons[1] == nil ? 95 : weapons[1].hit
      n = [n1, n2].min
    else
      n = weapons[0] == nil ? 95 : weapons[0].hit
    end
    # Adds bonus for the battle formation
    if $game_temp.in_battle
      n *= calc_formation_bonus_rate(PARTY_CONFIG::BF_BONUS_HIT) / 100.0
    end
    return n
  end
  
  #--------------------------------------------------------------------------
  # * Get Evasion Rate
  #--------------------------------------------------------------------------
  # GET
  def eva
    n = 5
    for item in armors.compact do n += item.eva end
    # Adds bonus for the battle formation
    if $game_temp.in_battle
      n *= calc_formation_bonus_rate(PARTY_CONFIG::BF_BONUS_EVA) / 100.0
    end
    return n
  end
  
  #--------------------------------------------------------------------------
  # * Get Critical Ratio
  #--------------------------------------------------------------------------
  # GET
  def cri
    n = 4
    n += 4 if actor.critical_bonus
    for weapon in weapons.compact
      n += 4 if weapon.critical_bonus
    end
    # Adds bonus for the battle formation
    if $game_temp.in_battle
      n *= calc_formation_bonus_rate(PARTY_CONFIG::BF_BONUS_CRI) / 100.0
    end
    return n
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #     actor_id : Actor ID
  #--------------------------------------------------------------------------
  alias initialize_ebjb initialize unless $@
  def initialize(actor_id)
    initialize_ebjb(actor_id)
    @party_locked = false
    @reserve_locked = false
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Calculation of battle formation bonus rate
  #     bonus_key : key of the bonus
  #--------------------------------------------------------------------------
  def calc_formation_bonus_rate(bonus_key)
    formation = PARTY_CONFIG::BATTLE_FORMATIONS[$game_party.battle_formation_index]
    line = formation.positions[self.index][1]
    # Get formation line bonus
    line_bonus = PARTY_CONFIG::FORMATION_LINES[line][bonus_key]
    # Get formation bonus
    formation_bonus = formation.bonuses[bonus_key]
    
    # Use 100% as the base rate (x * 100 / 100 == x)
    rate = 100
    rate += (line_bonus - 100) if line_bonus != nil
    rate += (formation_bonus - 100) if formation_bonus != nil
    
    return rate
  end
  private :calc_formation_bonus_rate
  
end
