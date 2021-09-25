################################################################################
#                          EBJB Party - EBJB_Party                    #   VX   #
#                          Last Update: 2012/03/17                    ##########
#                         Creation Date: 2011/07/14                            #
#                          Author : ChaosHades                                 #
#     Source :                                                                 #
#     http://www.google.com                                                    #
#------------------------------------------------------------------------------#
#  Contains custom scripts adding new features to the party in your game.      #
#  - Managing more than one party (based on Modern Algebra Multiple Parties)   #
#  - Party Changer to change party members for your party/parties              #
#  - Able to switch between party on the map with L/R buttons                  #
#  - Managing custom positions in the party                                    #
#  - Battle formations for your party with customizable bonuses                #
#  - Detailed description of the new battle formation is shown in the Battle   #
#    Formation window                                                          #
#==============================================================================#
#                         ** Instructions For Usage **                         #
#  There are settings that can be configured in the Party_Config class. For    #
#  more info on what and how to adjust these settings, see the documentation   #
#  in the class.                                                               #
#==============================================================================#
#                                ** Examples **                                #
#  See the documentation in each classes.                                      #
#==============================================================================#
#                           ** Installation Notes **                           #
#  Copy this script in the Materials section                                   #
#==============================================================================#
#                             ** Compatibility **                              #
#  Alias: Game_Party - initialize, setup_starting_members,                     #
#         setup_battle_test_members, gain_gold, increase_steps                 #
#  Alias: Game_Map - setup_events                                              #
#  Alias: Game_Actor - initialize                                              #
#  Alias: Scene_Menu - create_command_window, update_command_selection         #
#  Alias: Scene_Map - update_call_menu                                         #
#  Alias: Scene_Title - create_game_objects                                    #
#  Alias: Scene_File - read_save_data                                          #
#  Alias: Window_Status - refresh                                              #
################################################################################

$imported = {} if $imported == nil
$imported["EBJB_Party"] = true

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

#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles the party. It includes information on amount of gold 
# and items. The instance of this class is referenced by $game_party.
#==============================================================================

class Game_Party < Game_Unit
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Map ID of where the party is
  attr_accessor :map_id
  # Coordinates (X,Y) of where the party is on the map
  attr_accessor :player_x, :player_y
  # Post-movement direction of the party
  attr_accessor :player_direction
  # Event representing the party on the map
  attr_accessor :player_event
  # Array containing the actor positions in the party
  attr_accessor :actor_positions
  # Battle formation index
  attr_accessor :battle_formation_index
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set gold
  #--------------------------------------------------------------------------
  # SET
  def gold=(gold)
    @gold = gold
  end

  #--------------------------------------------------------------------------
  # * Set steps
  #--------------------------------------------------------------------------
  # SET
  def steps=(steps)
    @steps = steps
  end
  
  #--------------------------------------------------------------------------
  # * Get the items hash
  #--------------------------------------------------------------------------
  # GET
  def items_hash()
    return @items
  end
  
  #--------------------------------------------------------------------------
  # * Get the weapons hash
  #--------------------------------------------------------------------------
  # GET
  def weapons_hash()
    return @weapons
  end
  
  #--------------------------------------------------------------------------
  # * Get the armors hash
  #--------------------------------------------------------------------------
  # GET
  def armors_hash()
    return @armors
  end
  
  #--------------------------------------------------------------------------
  # * Get the index of the actor
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  # GET
  def index(actor_id)
    result = nil
    if @actors.include?(actor_id)
      result = @actor_positions[@actors.index(actor_id)]
    end
    return result
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias initialize_ebjb initialize unless $@
  def initialize
    initialize_ebjb
    @map_id = 0
    @player_x = 0
    @player_y = 0
    @player_direction = 2
    @player_event = nil
    @actor_positions = []
    @battle_formation_index = 0
    
    if $game_faction != nil
      # Sets the attributes to have the same gold, steps
      if PARTY_CONFIG::MERGE_GOLD
        @gold = $game_faction.game_parties[0].gold
      end
      if PARTY_CONFIG::MERGE_STEPS
        @steps = $game_faction.game_parties[0].steps 
      end
      # Adjusts the hashes to have the same items, weapons or armors
      if PARTY_CONFIG::MERGE_ITEMS
        @items = $game_faction.game_parties[0].items_hash
      end
      if PARTY_CONFIG::MERGE_WEAPONS
        @weapons = $game_faction.game_parties[0].weapons_hash
      end
      if PARTY_CONFIG::MERGE_ARMORS
        @armors = $game_faction.game_parties[0].armors_hash
      end
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias setup_starting_members
  #--------------------------------------------------------------------------
  alias setup_starting_members_ebjb setup_starting_members unless $@
  def setup_starting_members
    setup_starting_members_ebjb()
    # Sets the starting actors positions
    @actor_positions = []
    for i in 0 .. @actors.size-1
      @actor_positions.push(i)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias setup_battle_test_members
  #--------------------------------------------------------------------------
  alias setup_battle_test_members_ebjb setup_battle_test_members unless $@
  def setup_battle_test_members
    setup_battle_test_members_ebjb()
    # Sets the battle test actors positions
    @actor_positions = []
    for i in 0 .. @actors.size-1
      @actor_positions.push(i)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias gain_gold
  #     n : amount of gold
  #--------------------------------------------------------------------------
  alias gain_gold_ebjb gain_gold unless $@
  def gain_gold(n)
    gain_gold_ebjb(n)
    if PARTY_CONFIG::MERGE_GOLD
      $game_faction.merge_gold()
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias increase_steps
  #--------------------------------------------------------------------------
  alias increase_steps_ebjb increase_steps unless $@
  def increase_steps
    increase_steps_ebjb
    if PARTY_CONFIG::MERGE_STEPS
      $game_faction.merge_steps()
    end
  end
  
  #--------------------------------------------------------------------------
  # * Add an Actor
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def add_actor(actor_id)
    if not @actors.include?(actor_id)
      if @actors.size < MAX_MEMBERS
        @actors.push(actor_id)
        
        # Finds the free position for the new actor
        new_index = 0
        while @actor_positions.include?(new_index)
          new_index += 1 
        end
        @actor_positions.push(new_index)
        
        sort_arrays()
            
        $game_player.refresh
      else
        $game_faction.add_reserve_actor(actor_id)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Return the party members to the reserve
  #--------------------------------------------------------------------------
  def return_to_reserve()
    for i in @actors
      if i != nil && !$game_actors[i].party_locked
        $game_faction.add_reserve_actor(i)
      end
    end
    @actors = []
    @actor_positions = []
  end
  
  #--------------------------------------------------------------------------
  # * Insert an Actor at a specific index
  #     actor_id : actor ID
  #     index    : index to insert the actor
  #--------------------------------------------------------------------------
  def insert_actor(actor_id, index)
    if not @actors.include?(actor_id)
      if @actors.size < MAX_MEMBERS
        @actors.push(actor_id)
        @actor_positions.push(index)

        sort_arrays()

        $game_player.refresh
      else
        $game_faction.add_reserve_actor(actor_id)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Remove Actor
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def remove_actor(actor_id)
    if @actors.include?(actor_id)
      @actor_positions.delete_at(@actors.index(actor_id))
      @actors.delete(actor_id)
      $game_player.refresh
    end
  end

  #--------------------------------------------------------------------------
  # * Change Actor position
  #     actor_id : actor ID
  #     pos : new position
  #--------------------------------------------------------------------------  
  def change_actor_position(actor_id, pos)
    if @actors.include?(actor_id)
      @actor_positions[@actors.index(actor_id)] = pos
      
      sort_arrays()
      
      $game_player.refresh
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Sort Actors Arrays
  #--------------------------------------------------------------------------
  def sort_arrays()
    # Sorts in new array because @actors.index will change if in self
    @actors = @actors.sort{|x,y| sort_actors(self.index(x),
                                             self.index(y)) }
    @actor_positions.sort!
  end
  private :sort_arrays
  
  #--------------------------------------------------------------------------
  # * Sort Actors
  #     x : first position to compare
  #     y : second position to compare
  #--------------------------------------------------------------------------
  def sort_actors(x, y)
    if x < y
      result = -1
    elsif x > y
      result = 1
    elsif x == y
      result = 0
    end
    
    return result
  end
  private :sort_actors
  
end

#==============================================================================
# ** Game_Parties
#------------------------------------------------------------------------------
#  This class handles Parties. It's a wrapper for the built-in class "Array."
#  It is accessed by $game_parties
#==============================================================================

class Game_Parties
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the size of the data in game_parties
  #--------------------------------------------------------------------------
  def size()
    return @data.size
  end
  
end

#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles maps. It includes scrolling and passage determination
# functions. The instance of this class is referenced by $game_map.
#==============================================================================

class Game_Map

  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Add a custom event
  #     event : event to add
  #--------------------------------------------------------------------------
  def add_custom_event(event)
    if event != nil
      event.id = generate_event_id()
      @events[event.id] = Game_Event.new(@map_id, event)
      @need_refresh = true
    end
  end
  
  #--------------------------------------------------------------------------
  # * Remove a custom event
  #     id : id of the event to remove
  #--------------------------------------------------------------------------
  def remove_custom_event(id)
    if id != nil
      if @events.include?(id)
        @events.delete(id)
      end
      @need_refresh = true
    end
  end

  #--------------------------------------------------------------------------
  # * Alias setup_events
  #--------------------------------------------------------------------------
  alias setup_events_ebjb setup_events unless $@
  def setup_events
    setup_events_ebjb
    $game_faction.generate_parties_events()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Generate new event ID
  #--------------------------------------------------------------------------
  def generate_event_id()
    id = 1
    id += 1 while @events.include?(id)
    return id
  end
  private :generate_event_id
  
end

#==============================================================================
# ** Game_Faction
#------------------------------------------------------------------------------
#  This class handles the reserve and the parties.
#==============================================================================

class Game_Faction
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Current party index
  attr_reader :party_index
  # Game parties array (Game_Party)
  attr_reader :game_parties
  # Reserve members array (actor ID)
  attr_reader :reserve_actors
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get number of active parties
  #--------------------------------------------------------------------------
  # GET
  def nbr_active_parties()
    return @game_parties.size
  end

  #--------------------------------------------------------------------------
  # * Get Reserve Members
  #--------------------------------------------------------------------------
  # GET
  def reserve_members
    result = []
    for i in @reserve_actors
      result.push($game_actors[i])
    end
    return result
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @party_index = 0
    @game_parties = Game_Parties.new()
    @reserve_actors = []
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Switch to Next Party
  #--------------------------------------------------------------------------
  def next_party()
    @party_index += 1
    @party_index %= @game_parties.size
    change_party()
  end
  
  #--------------------------------------------------------------------------
  # * Switch to Previous Party
  #--------------------------------------------------------------------------
  def prev_party()
    @party_index += @game_parties.size - 1
    @party_index %= @game_parties.size
    change_party()
  end
  
  #--------------------------------------------------------------------------
  # * Merge Gold (or lose)
  #--------------------------------------------------------------------------
  def merge_gold()
    for i in 0 .. @game_parties.size-1
      # Sets gold for the other parties
      if i != @party_index
        @game_parties[i].gold = @game_parties[@party_index].gold
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Merge Steps
  #--------------------------------------------------------------------------
  def merge_steps()
    for i in 0 .. @game_parties.size-1
      # Sets steps for the other parties
      if i != @party_index
        @game_parties[i].steps = @game_parties[@party_index].steps
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Get Array of All Living Members
  #--------------------------------------------------------------------------
  def existing_reserve_members
    result = []
    for battler in reserve_members
      next unless battler.exist?
      result.push(battler)
    end
    return result
  end
  
  #--------------------------------------------------------------------------
  # * Add an Actor to the Reserve
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def add_reserve_actor(actor_id)
    if not @reserve_actors.include?(actor_id)
      @reserve_actors.push(actor_id)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Insert an Actor to the Reserve
  #     actor_id : actor ID
  #     index    : index to insert the actor
  #--------------------------------------------------------------------------
  def insert_reserve_actor(actor_id, index)
    if not @reserve_actors.include?(actor_id)
      @reserve_actors.insert(index, actor_id)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Remove Actor from the Reserve
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def remove_reserve_actor(actor_id)
    if @reserve_actors.include?(actor_id)
      @reserve_actors.delete(actor_id)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Reset parties
  #--------------------------------------------------------------------------
  def reset_parties()
    for i in 0 .. @game_parties.size-1
      # Returns every party members to the reserve
      @game_parties[i].return_to_reserve()
      if $game_map.map_id == @game_parties[i].map_id
        # Removes the current custom event for the game party
        $game_map.remove_custom_event(@game_parties[i].player_event.id)
      end
    end
    
    @party_index = 0
    @game_parties = Game_Parties.new()
  end
  
  #--------------------------------------------------------------------------
  # * Generates parties player event
  #--------------------------------------------------------------------------
  def generate_parties_events()
    for i in 0 .. @game_parties.size-1
      # Adds the event only if this is in the current map and not the current party
      if $game_map.map_id == @game_parties[i].map_id && i != @party_index
        $game_map.add_custom_event(@game_parties[i].player_event)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update custom events for the parties
  #--------------------------------------------------------------------------
  def update_parties_events()
    for i in 0 .. @game_parties.size-1
      if i != @party_index

        actor = @game_parties[i].members[0]   # Get front actor       
        if @game_parties[i].player_event != nil
          
          event = @game_parties[i].player_event
          
          if $game_map.map_id == @game_parties[i].map_id &&
             event.pages[0].graphic.character_name != actor.character_name &&
             event.pages[0].graphic.character_index != actor.character_index 
             
            # Removes the current custom event for the game party
            $game_map.remove_custom_event(event.id)
            
            # Updates the charset info
            event.pages[0].graphic.character_name = actor.character_name 
            event.pages[0].graphic.character_index = actor.character_index 
            
            # Add the event and determines the id
            $game_map.add_custom_event(event)
          end
        else
          event = create_party_event(actor.character_name, actor.character_index)
          # Add the event and determines the id
          $game_map.add_custom_event(event)

          # Updates map & player info
          update_map_player_info(@game_parties[i], event)
        end
      end
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Change Party
  #--------------------------------------------------------------------------
  def change_party()
    # Removes the current custom event for the game party
    $game_map.remove_custom_event(@game_parties[@party_index].player_event.id)
    
    event = create_party_event($game_player.character_name, $game_player.character_index)
    # Add the event and determines the id
    $game_map.add_custom_event(event)
    
    # Updates map & player info
    update_map_player_info($game_party, event)
    
    # Performs the party change
    $game_party = @game_parties[@party_index]
    $game_player.refresh
  end
  private :change_party
  
  #--------------------------------------------------------------------------
  # * Create an event that represents the party
  #     character_name : character graphic filename
  #     character_index : character graphic index
  #--------------------------------------------------------------------------
  def create_party_event(character_name, character_index)
    event = RPG::Event.new($game_player.x, $game_player.y)
    event.pages[0].priority_type = 1
    event.pages[0].graphic.tile_id = $game_player.tile_id
    event.pages[0].graphic.character_name = character_name 
    event.pages[0].graphic.character_index = character_index 
    event.pages[0].graphic.direction = $game_player.direction  
    event.pages[0].graphic.pattern = $game_player.pattern

    return event
  end
  private :create_party_event
  
  #--------------------------------------------------------------------------
  # * Updates map & player info in party
  #     party : party to update
  #     event : player event that represents the party
  #--------------------------------------------------------------------------
  def update_map_player_info(party, event)
    party.map_id = $game_map.map_id
    party.player_x = $game_player.x
    party.player_y = $game_player.y
    party.player_direction = $game_player.direction
    party.player_event = event
  end
  private :update_map_player_info
  
end

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

#===============================================================================
# ** Scene Menu
#------------------------------------------------------------------------------
#  Add the Party & Formation item in the menu
#===============================================================================

class Scene_Menu < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias create_command_window
  #--------------------------------------------------------------------------
  alias create_command_window_ebjb create_command_window unless $@
  def create_command_window
    # Keeps the selected index and cancel the @menu_index
    # (because in the original create_command_window, 
    # this line is called after the creation of the window :
    #   @command_window.index = @menu_index
    # and with a command that doesn't exist, the index will be invalid)
    temp_index = @menu_index
    @menu_index = -1
    create_command_window_ebjb
    @command_party = @command_window.add_command(Vocab::party_menu_title)
    @command_formation = @command_window.add_command(Vocab::formation_menu_title)
    # Finally, apply the index when all the necessary commands are added
    @command_window.index = temp_index
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_command_selection
  #--------------------------------------------------------------------------
  alias update_command_selection_ebjb update_command_selection unless $@
  def update_command_selection
    if Input.trigger?(Input::C)
      case @command_window.index
      when @command_party
        Sound.play_decision
        $scene = Scene_Party.new(nil, @command_window.index)
      when @command_formation
        Sound.play_decision
        $scene = Scene_Formation.new(@command_window.index)
      end
    end
    update_command_selection_ebjb
  end
  
end

#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs the map screen processing.
#==============================================================================

class Scene_Map < Scene_Base
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias update_call_menu
  #--------------------------------------------------------------------------
  alias update_call_menu_ebjb update_call_menu unless $@
  def update_call_menu
    update_call_menu_ebjb
    if $game_faction.nbr_active_parties > 1
      if Input.trigger?(Input::R)
        Sound.play_cursor
        fadeout(30)
        $game_faction.next_party()
        party_transition()
        fadein(30)
      elsif Input.trigger?(Input::L)
        Sound.play_cursor
        fadeout(30)
        $game_faction.prev_party()
        party_transition()
        fadein(30)
      end
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Do the transition with the new party
  #--------------------------------------------------------------------------
  def party_transition()
    # Teleports to the party location
    $game_player.reserve_transfer($game_party.map_id, $game_party.player_x, 
                                  $game_party.player_y, $game_party.player_direction)
    update_transfer_player()
  end
  private :party_transition
  
end

#==============================================================================
# ** Scene_Title
#--------------------------------------------------------------------------
#  This class performs the title screen processing.
#==============================================================================

class Scene_Title < Scene_Base
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Alias create_game_objects
  #--------------------------------------------------------------------------
  alias create_game_objects_ebjb create_game_objects unless $@
  def create_game_objects
    create_game_objects_ebjb
    $game_faction      = Game_Faction.new
  end
  
end

#==============================================================================
# ** Scene_File
#--------------------------------------------------------------------------
#  This class performs the save and load screen processing.
#==============================================================================

class Scene_File
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Write Save Data
  #     file : write file object (opened)
  #--------------------------------------------------------------------------
  def write_save_data(file)
    characters = []
    for actor in $game_party.members
      characters.push([actor.character_name, actor.character_index, actor.index])
    end
    $game_system.save_count += 1
    $game_system.version_id = $data_system.version_id
    @last_bgm = RPG::BGM::last
    @last_bgs = RPG::BGS::last
    Marshal.dump(characters,           file)
    Marshal.dump(Graphics.frame_count, file)
    Marshal.dump(@last_bgm,            file)
    Marshal.dump(@last_bgs,            file)
    Marshal.dump($game_system,         file)
    Marshal.dump($game_message,        file)
    Marshal.dump($game_switches,       file)
    Marshal.dump($game_variables,      file)
    Marshal.dump($game_self_switches,  file)
    Marshal.dump($game_actors,         file)
    Marshal.dump($game_party,          file)
    Marshal.dump($game_troop,          file)
    Marshal.dump($game_map,            file)
    Marshal.dump($game_player,         file)
    
    Marshal.dump($game_faction,        file)
  end
  
  #--------------------------------------------------------------------------
  # * Alias read_save_data
  #     file : file object for reading (opened)
  #--------------------------------------------------------------------------
  alias read_save_data_ebjb read_save_data  unless $@
  def read_save_data(file)
    read_save_data_ebjb (file)
    $game_faction        = Marshal.load(file)
    # Updates charset on the map
    $game_faction.update_parties_events()
  end
  
end

#==============================================================================
# ** Scene_Party
#------------------------------------------------------------------------------
#  This class performs the party change screen processing.
#==============================================================================

class Scene_Party < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     nbr_parties : number of parties to form
  #     menu_index : menu index
  #--------------------------------------------------------------------------
  def initialize(nbr_parties = nil, menu_index = nil)
    if nbr_parties == nil
      # Gets the current number of parties
      nbr_parties = $game_faction.nbr_active_parties
    elsif nbr_parties != $game_faction.nbr_active_parties
      # Resets parties when changing number of active parties
      $game_faction.reset_parties()
    end
    @nbr_parties = nbr_parties
    @menu_index = menu_index
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_menu_background
    if PARTY_CONFIG::IMAGE_BG != ""
      @bg = Sprite.new
      @bg.bitmap = Cache.picture(PARTY_CONFIG::IMAGE_BG)
      @bg.opacity = PARTY_CONFIG::IMAGE_BG_OPACITY
    end
    
    @help_window = Window_Info_Help.new(0, 0, 640, 56, sprintf(Vocab::party_help_text, @nbr_parties))
    @help_window.cText.align = 1
    # Refresh for the text alignment
    @help_window.refresh()
    
    @member_info_window = Window_Member_Info.new(160, 56, 480, 128, nil)
    @member_info_window.visible = false
    @reserve_members_window = Window_Reserve_Members.new(0, 184, 640, 168, $game_faction.reserve_members)
    @reserve_members_window.active = false
    @reserve_members_window.index = -1
    @reserve_members_window.help_window = @member_info_window
    
    @party_members_backup = []
    @party_selection_windows = []
    for i in 0 .. @nbr_parties-1
      @party_members_backup[i] = [$game_faction.game_parties[i].members, $game_faction.game_parties[i].actor_positions]
      party_selection_window = Window_Party_Selection.new(160*i, 352, 160, 128, i, $game_faction.game_parties[i].members)
      party_selection_window.active = false
      party_selection_window.index = -1
      party_selection_window.help_window = @member_info_window
      @party_selection_windows.push(party_selection_window)
    end
    
    @command_window = Window_Command.new(160, 
                                         [Vocab::party_change_command, 
                                          Vocab::party_revert_command, 
                                          Vocab::party_empty_command])
    @command_window.x = 0
    @command_window.y = 56
    @command_window.height = @member_info_window.height
    @command_window.active = true
    
    @status_window = Window_Status.new(nil)
    width_remain = (640 - @status_window.width)/2
    @status_window.x = width_remain.floor
    height_remain = (480 - @status_window.height)/2
    @status_window.y = height_remain.floor
    @status_window.visible = false
    @status_window.active = false
    
    @selected_party_index = -1
        
    [@help_window, @reserve_members_window, @member_info_window,
     @command_window, @status_window]+@party_selection_windows.each{
      |w| w.opacity = PARTY_CONFIG::WINDOW_OPACITY;
          w.back_opacity = PARTY_CONFIG::WINDOW_BACK_OPACITY
    }
  end
  
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background()
    
    unless @bg.nil?
      @bg.bitmap.dispose
      @bg.dispose
    end
    @help_window.dispose if @help_window != nil
    @reserve_members_window.dispose if @reserve_members_window != nil
    @member_info_window.dispose if @member_info_window != nil
    @command_window.dispose if @command_window != nil
    @status_window.dispose if @status_window != nil
    for w in @party_selection_windows
      w.dispose if w != nil
    end
  end
  
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_menu_background()
    
    @help_window.update
    @reserve_members_window.update
    @member_info_window.update
    @command_window.update
    @status_window.update
    for w in @party_selection_windows
      w.update
    end
    
    if @command_window.active
      update_command_selection()
    elsif @reserve_members_window.active
      update_reserve_selection()
    elsif @party_selection_windows[@selected_party_index].active
      update_party_selection()
    end
    
    if @status_window.visible
      update_status_selection()
    end
    
  end

  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Return scene
  #--------------------------------------------------------------------------
  def return_scene
    # Updates charset on the map
    $game_faction.update_parties_events()
    
    if @menu_index != nil
      $scene = Scene_Menu.new(@menu_index)
    else
      $scene = Scene_Map.new
    end
  end
  private :return_scene
  
  #--------------------------------------------------------------------------
  # * Updates actor status (use status window)
  #--------------------------------------------------------------------------
  def update_actor_status()
    
    # Updates Status window if is visible
    if @status_window.visible
      if Input.repeat?(Input::DOWN) || Input.repeat?(Input::UP) ||
         Input.repeat?(Input::LEFT) || Input.repeat?(Input::RIGHT)
         
        if @reserve_members_window.selected_reserve_actor != nil
          status_command(@reserve_members_window.selected_reserve_actor)
        elsif @status_window.visible && @party_selection_windows[@selected_party_index].selected_actor != nil
          status_command(@party_selection_windows[@selected_party_index].selected_actor)
        else
          cancel_status_command()
        end
         
      end
    end
    
  end
  private :update_actor_status
  
  #--------------------------------------------------------------------------
  # * Manage the available changes (reserve <-> party, party <-> party)
  #     party_index : selected party index
  #     reserve_actor : selected reserve actor object
  #     reserve_actor_index : selected reserve actor index
  #     party_actor1 : selected party actor
  #     party_actor1_index : selected party actor index
  #     party_actor2 : second selected party actor
  #     party_actor2_index : second selected party actor index
  #     second_party_index : second party index
  #--------------------------------------------------------------------------  
  def party_change(party_index, reserve_actor, reserve_actor_index, 
                   party_actor1, party_actor1_index, 
                   party_actor2=nil, party_actor2_index=nil, second_party_index=nil)
    change_done = false
    
    # Transactions between parties
    if second_party_index != nil
      
      # Two empty spaces between two parties
      if party_actor1 == nil && party_actor2 == nil

        # Nothing to do, only refresh to remove the selected indexes
        change_done = true
        
      # Add to another selected party
      elsif party_actor1 != nil && party_actor2 == nil
        
        $game_faction.game_parties[party_index].remove_actor(party_actor1.id)
        $game_faction.game_parties[second_party_index].insert_actor(party_actor1.id, party_actor2_index)
        change_done = true
        
      # Add to another selected party
      elsif party_actor1 == nil && party_actor2 != nil
        
        $game_faction.game_parties[second_party_index].remove_actor(party_actor2.id)
        $game_faction.game_parties[party_index].insert_actor(party_actor2.id, party_actor1_index)
        change_done = true
        
      # Switch between two parties
      elsif party_actor1 != nil && party_actor2 != nil

        $game_faction.game_parties[party_index].remove_actor(party_actor1.id)
        $game_faction.game_parties[second_party_index].remove_actor(party_actor2.id)
        $game_faction.game_parties[second_party_index].insert_actor(party_actor1.id, party_actor2_index)
        $game_faction.game_parties[party_index].insert_actor(party_actor2.id, party_actor1_index)
        change_done = true
        
      end
    
    # Transactions in same party
    elsif reserve_actor == nil && reserve_actor_index == nil

      # Two empty spaces in the same party
      if party_actor1 == nil && party_actor2 == nil

        # Nothing to do, only refresh to remove the selected indexes
        change_done = true
      
      # Switch position in the same party
      elsif party_actor1 != nil && party_actor2 == nil
        
        $game_faction.game_parties[party_index].remove_actor(party_actor1.id)
        $game_faction.game_parties[party_index].insert_actor(party_actor1.id, party_actor2_index)
        change_done = true
        
      # Switch position in the same party
      elsif party_actor1 == nil && party_actor2 != nil
        
        $game_faction.game_parties[party_index].remove_actor(party_actor2.id)
        $game_faction.game_parties[party_index].insert_actor(party_actor2.id, party_actor1_index)
        change_done = true
      
      # Switch between same party
      elsif party_actor1 != nil && party_actor2 != nil

        $game_faction.game_parties[party_index].remove_actor(party_actor1.id)
        $game_faction.game_parties[party_index].remove_actor(party_actor2.id)
        $game_faction.game_parties[party_index].insert_actor(party_actor1.id, party_actor2_index)
        $game_faction.game_parties[party_index].insert_actor(party_actor2.id, party_actor1_index)
        change_done = true
        
      end
    
    # Transactions between reserve and a party
    else

      # Two empty spaces between two parties
      if reserve_actor == nil && party_actor1 == nil

        # Nothing to do, only refresh to remove the selected indexes
        change_done = true
      
      # Add to the party
      elsif reserve_actor != nil && party_actor1 == nil
        
        $game_faction.remove_reserve_actor(reserve_actor.id)
        $game_faction.game_parties[party_index].insert_actor(reserve_actor.id, party_actor1_index)
        change_done = true
        
      # Return to the reserve
      elsif reserve_actor == nil && party_actor1 != nil
      
        $game_faction.game_parties[party_index].remove_actor(party_actor1.id)
        $game_faction.add_reserve_actor(party_actor1.id)
        change_done = true
        
      # Switch between reserve and the party
      elsif reserve_actor != nil && party_actor1 != nil
        
        $game_faction.remove_reserve_actor(reserve_actor.id)
        $game_faction.game_parties[party_index].remove_actor(party_actor1.id)
        $game_faction.insert_reserve_actor(party_actor1.id, reserve_actor_index)
        $game_faction.game_parties[party_index].insert_actor(reserve_actor.id, party_actor1_index)
        change_done = true
        
      end
      
    end
    
    return change_done
  end
  private :party_change
    
  #//////////////////////////////////////////////////////////////////////////
  # * Scene input management methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update Command Selection
  #--------------------------------------------------------------------------
  def update_command_selection()
    if Input.trigger?(Input::B)
      # Checks if there are no empty parties
      no_empty_nbr_parties = true
      for i in 0 .. @nbr_parties-1
        no_empty_nbr_parties &= ($game_faction.game_parties[i].members.size > 0)
      end
      
      if !no_empty_nbr_parties
        Sound.play_buzzer
        @help_window.window_update(sprintf(Vocab::empty_parties_warning_text, @nbr_parties))
      else
        Sound.play_cancel
        quit_command()
      end
     
    elsif Input.trigger?(Input::C)
      case @command_window.index
      when 0  # Change
        Sound.play_decision
        change_command()
      when 1  # Revert
        Sound.play_decision
        revert_command()
      when 2  # Empty Group(s)
        Sound.play_decision
        empty_command()
      end
      @help_window.window_update(sprintf(Vocab::party_help_text, @nbr_parties))
    end
    
  end
  private :update_command_selection
  
  #--------------------------------------------------------------------------
  # * Update Reserve Member Selection
  #--------------------------------------------------------------------------
  def update_reserve_selection
    if Input.trigger?(Input::B)
      
      if @reserve_members_window.nbr_selected_indexes == 0 && 
         !@status_window.visible
        Sound.play_cancel
        cancel_command()       
      end
      
    elsif Input.trigger?(Input::C)
      
      if @reserve_members_window.selected_reserve_actor == nil ||
         !@reserve_members_window.selected_reserve_actor.reserve_locked
      
        nbr_indexes = 0
        for i in 0 .. @party_selection_windows.size-1
          nbr_indexes += @party_selection_windows[i].nbr_selected_indexes
        end
        nbr_indexes += @reserve_members_window.nbr_selected_indexes

        if nbr_indexes == 2
          Sound.play_decision
          do_party_command()
        end
        
      end
        
    elsif Input.trigger?(Input::A)
      if @reserve_members_window.selected_reserve_actor == nil
        Sound.play_buzzer
      else
        Sound.play_decision
        status_command(@reserve_members_window.selected_reserve_actor)
      end
      
    elsif Input.repeat?(Input::DOWN)
      if @reserve_members_window.cursor_transfer
        
        # Determines the index to select the party to use for the party change
        party_index = @reserve_members_window.index
        party_index %= @reserve_members_window.column_max
        party_index /= @party_selection_windows[@selected_party_index].column_max

        if party_index < @nbr_parties
          Sound.play_cursor
          party_command(party_index)
        end
      end
    end
    
    update_actor_status()
    
  end
  private :update_reserve_selection

  #--------------------------------------------------------------------------
  # * Update Party Selection
  #--------------------------------------------------------------------------
  def update_party_selection    
    if Input.trigger?(Input::B)
      
      if @party_selection_windows[@selected_party_index].nbr_selected_indexes == 0 && 
         !@status_window.visible
        Sound.play_cancel
        cancel_command()
      end
      
    elsif Input.trigger?(Input::C)
      
      if @party_selection_windows[@selected_party_index].selected_actor == nil ||
         !@party_selection_windows[@selected_party_index].selected_actor.party_locked
      
        nbr_indexes = 0
        for i in 0 .. @party_selection_windows.size-1
          nbr_indexes += @party_selection_windows[i].nbr_selected_indexes
        end
        nbr_indexes += @reserve_members_window.nbr_selected_indexes
        
        if nbr_indexes == 2
          Sound.play_decision
          do_party_command()
        end
        
      end
    
    elsif Input.trigger?(Input::A)
      if @party_selection_windows[@selected_party_index].selected_actor == nil
        Sound.play_buzzer
      else
        Sound.play_decision
        status_command(@party_selection_windows[@selected_party_index].selected_actor)
      end
      
    elsif Input.repeat?(Input::UP)
      if @party_selection_windows[@selected_party_index].cursor_transfer
        
        # Determines if we can return to the reserve window
        temp = @party_selection_windows[@selected_party_index].index
        temp += @selected_party_index * @party_selection_windows[@selected_party_index].column_max

        if temp < @reserve_members_window.item_max
          Sound.play_cursor
          cancel_party_command()
        end
        
      end
      
    elsif Input.repeat?(Input::RIGHT)
      if @party_selection_windows[@selected_party_index].cursor_transfer
        Sound.play_cursor
        next_party_command()
      end
      
    elsif Input.repeat?(Input::LEFT)
      if @party_selection_windows[@selected_party_index].cursor_transfer
        Sound.play_cursor
        prev_party_command()
      end
      
    end
    
    update_actor_status()
    
  end
  private :update_party_selection
  
  #--------------------------------------------------------------------------
  # * Update Status Selection
  #--------------------------------------------------------------------------
  def update_status_selection
    if Input.trigger?(Input::B)
      Sound.play_cancel
      cancel_status_command()
    end
  end
  private :update_party_selection
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene Commands
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Cancel command
  #--------------------------------------------------------------------------
  def cancel_command()
    @command_window.active = true
    @reserve_members_window.clean_indexes()
    @reserve_members_window.active = false
    @reserve_members_window.index = -1
    @selected_party_index = -1
    for w in @party_selection_windows
      w.clean_indexes()
      w.active = false
      w.index = -1
    end
    @member_info_window.window_update(nil)
    @member_info_window.visible = false
  end
  private :cancel_command
  
  #--------------------------------------------------------------------------
  # * Quit command
  #--------------------------------------------------------------------------
  def quit_command()
    return_scene
  end
  private :quit_command

  #--------------------------------------------------------------------------
  # * Change command
  #--------------------------------------------------------------------------
  def change_command()
    @command_window.active = false
    @reserve_members_window.active = true
    @reserve_members_window.index = 0
    if @reserve_members_window.selected_reserve_actor != nil
      @member_info_window.window_update(@reserve_members_window.selected_reserve_actor)
      @member_info_window.visible = true
    end
  end
  private :change_command

  #--------------------------------------------------------------------------
  # * Revert command
  #--------------------------------------------------------------------------
  def revert_command()
    for i in 0 .. $game_faction.game_parties.size-1
      $game_faction.game_parties[i].return_to_reserve()
    end

    # Revert changes
    for i in 0 .. @party_members_backup.size-1
      actors = @party_members_backup[i][0]
      positions = @party_members_backup[i][1]
      for j in 0 .. actors.size-1
        $game_faction.game_parties[i].insert_actor(actors[j].id, positions[j])
        $game_faction.remove_reserve_actor(actors[j].id)
      end
    end
    
    @reserve_members_window.window_update($game_faction.reserve_members)
    
    for i in 0 .. @party_selection_windows.size-1
      @party_selection_windows[i].window_update($game_faction.game_parties[i].members)
    end
  end
  private :revert_command
  
  #--------------------------------------------------------------------------
  # * Empty command
  #--------------------------------------------------------------------------
  def empty_command()
    for i in 0 .. $game_faction.game_parties.size-1
      $game_faction.game_parties[i].return_to_reserve()
    end
    @reserve_members_window.window_update($game_faction.reserve_members)
    
    for i in 0 .. @party_selection_windows.size-1
      @party_selection_windows[i].window_update($game_faction.game_parties[i].members)
    end
  end
  private :empty_command
  
  #--------------------------------------------------------------------------
  # * Party command
  #     party_index : New party index
  #--------------------------------------------------------------------------
  def party_command(party_index)
    @selected_party_index = party_index
    @party_selection_windows[@selected_party_index].active = true
    
    # Determines the index to select the actor in the party selection window
    actor_index = @reserve_members_window.index
    actor_index %= @reserve_members_window.column_max
    actor_index -= @selected_party_index * @party_selection_windows[@selected_party_index].column_max
    
    @party_selection_windows[@selected_party_index].index = actor_index
    @reserve_members_window.active = false
    @reserve_members_window.index = -1
  end
  private :party_command  
  
  #--------------------------------------------------------------------------
  # * Cancel Party command
  #--------------------------------------------------------------------------
  def cancel_party_command()
    @reserve_members_window.active = true
    
    # Determines the index to select the actor in the reserve window
    actor_index = @party_selection_windows[@selected_party_index].index
    actor_index += @selected_party_index * @party_selection_windows[@selected_party_index].column_max

    if (actor_index + @reserve_members_window.column_max * (@reserve_members_window.row_max-1)) < @reserve_members_window.item_max
      actor_index += @reserve_members_window.column_max * (@reserve_members_window.row_max-1)
    end
    
    @reserve_members_window.index = actor_index
    @party_selection_windows[@selected_party_index].active = false
    @party_selection_windows[@selected_party_index].index = -1
    @selected_party_index = -1
  end
  private :cancel_party_command 
  
  #--------------------------------------------------------------------------
  # * Do Party command
  #--------------------------------------------------------------------------
  def do_party_command()
    change_done = false
    party_index = nil
    second_party_index = nil
    
    if @selected_party_index < 0
      i = 0
      # Finds the selected party
      while i < @party_selection_windows.size && party_index == nil
        if @party_selection_windows[i].nbr_selected_indexes > 0
          party_index = i
        end
        i+=1
      end
    else
      party_index = @selected_party_index
      i = 0
      # Finds the other selected party
      while i < @party_selection_windows.size && second_party_index == nil
        if @party_selection_windows[i].nbr_selected_indexes > 0 &&
           i != @selected_party_index
          second_party_index = i
        end
        i+=1
      end
    end
    
    if @reserve_members_window.nbr_selected_indexes == 2 
       
       # Nothing to do, only refresh to remove the selected indexes
       change_done = true
    
    elsif second_party_index != nil

      change_done = party_change(party_index, nil, nil,
                                 @party_selection_windows[party_index].selected_actor,
                                 @party_selection_windows[party_index].index,
                                 @party_selection_windows[second_party_index].selected_actor,
                                 @party_selection_windows[second_party_index].index,
                                 second_party_index)
                                 
    elsif @reserve_members_window.nbr_selected_indexes == 1

      change_done = party_change(party_index, 
                                 @reserve_members_window.selected_reserve_actor,
                                 @reserve_members_window.index,
                                 @party_selection_windows[party_index].selected_actor,
                                 @party_selection_windows[party_index].index)

    else

      change_done = party_change(party_index, nil, nil,
                                 @party_selection_windows[party_index].selected_actor(0),
                                 @party_selection_windows[party_index].index(0),
                                 @party_selection_windows[party_index].selected_actor(1),
                                 @party_selection_windows[party_index].index(1))
    
    end
    
    if change_done 
      @reserve_members_window.clean_indexes()
      @reserve_members_window.window_update($game_faction.reserve_members)
      for i in 0 .. @party_selection_windows.size-1
        @party_selection_windows[i].clean_indexes()
        @party_selection_windows[i].window_update($game_faction.game_parties[i].members)
      end

      if @reserve_members_window.active
        @reserve_members_window.update_help
      elsif @party_selection_windows[@selected_party_index].active
        @party_selection_windows[@selected_party_index].update_help
      end
    end
  end
  private :do_party_command

  #--------------------------------------------------------------------------
  # * Status command
  #     actor : Actor object
  #--------------------------------------------------------------------------
  def status_command(actor)
    @status_window.actor = actor
    @status_window.refresh
    @status_window.visible = true
  end
  private :status_command  
  
  #--------------------------------------------------------------------------
  # * Cancel Status command
  #--------------------------------------------------------------------------
  def cancel_status_command()
    @status_window.actor = nil
    @status_window.refresh
    @status_window.visible = false
  end
  private :cancel_status_command  

  #--------------------------------------------------------------------------
  # * Switch to Next Party Screen command
  #--------------------------------------------------------------------------
  def next_party_command()
    @party_selection_windows[@selected_party_index].active = false
    index = @party_selection_windows[@selected_party_index].index-1
    @party_selection_windows[@selected_party_index].index = -1
    
    # Determines the index to select the actor in the next party window
    party_index = @selected_party_index + 1
    party_index %= $game_faction.game_parties.size
    @selected_party_index = party_index
    
    @party_selection_windows[@selected_party_index].update_help
    @party_selection_windows[@selected_party_index].active = true
    @party_selection_windows[@selected_party_index].index = index
  end
  private :next_party_command
  
  #--------------------------------------------------------------------------
  # * Switch to Previous Party Screen command
  #--------------------------------------------------------------------------
  def prev_party_command()
    @party_selection_windows[@selected_party_index].active = false
    index = @party_selection_windows[@selected_party_index].index+1
    @party_selection_windows[@selected_party_index].index = -1
    
    # Determines the index to select the actor in the prev party window
    party_index = @selected_party_index + $game_faction.game_parties.size - 1
    party_index %= $game_faction.game_parties.size
    @selected_party_index = party_index
    
    @party_selection_windows[@selected_party_index].update_help
    @party_selection_windows[@selected_party_index].active = true
    @party_selection_windows[@selected_party_index].index = index
  end
  private :prev_party_command
  
end

#==============================================================================
# ** Scene_Formation
#------------------------------------------------------------------------------
#  This class performs the battle formation screen processing.
#==============================================================================

class Scene_Formation < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     menu_index : menu index
  #--------------------------------------------------------------------------
  def initialize(menu_index = nil)
    @menu_index = menu_index
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_menu_background
    if PARTY_CONFIG::IMAGE_BG != ""
      @bg = Sprite.new
      @bg.bitmap = Cache.picture(PARTY_CONFIG::IMAGE_BG)
      @bg.opacity = PARTY_CONFIG::IMAGE_BG_OPACITY
    end
    
    @actor_positions_backup = {}
    for i in 0 .. $game_party.members.size-1
      @actor_positions_backup[$game_party.members[i].id] = $game_party.actor_positions[i]
    end
    @party_order_window = Window_Party_Order.new(160, 0, 480, 156, $game_party.members)
    @party_order_window.active = false
    @party_order_window.index = -1

    @command_window = Window_Command.new(160, 
                                         [Vocab::formation_change_command, 
                                          Vocab::formation_order_command, 
                                          Vocab::formation_revert_command])
    @command_window.x = 0
    @command_window.y = 0
    @command_window.height = @party_order_window.height
    @command_window.active = true
    
    @help_window = Window_Info_Help.new(0, 384, 640, 96, nil)
    @battle_formation_details_window = Window_BattleFormationDetails.new(0,384,640,96,nil)
    @battle_formation_details_window.visible = false

    @battle_formation_index_backup = $game_party.battle_formation_index
    @battle_formations_window = Window_Battle_Formations.new(0, 156, 640, 228, PARTY_CONFIG::BATTLE_FORMATIONS)
    @battle_formations_window.active = false
    @battle_formations_window.index = $game_party.battle_formation_index
    @battle_formations_window.help_window = @help_window
    @battle_formations_window.detail_window = @battle_formation_details_window
        
    [@help_window, @battle_formation_details_window, @party_order_window,
     @command_window, @battle_formations_window].each{
      |w| w.opacity = PARTY_CONFIG::WINDOW_OPACITY;
          w.back_opacity = PARTY_CONFIG::WINDOW_BACK_OPACITY
    }
  end
  
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background()
    
    unless @bg.nil?
      @bg.bitmap.dispose
      @bg.dispose
    end
    @help_window.dispose if @help_window != nil
    @battle_formation_details_window.dispose if @battle_formation_details_window != nil
    @party_order_window.dispose if @party_order_window != nil
    @command_window.dispose if @command_window != nil
    @battle_formations_window.dispose if @battle_formations_window != nil
  end
  
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_menu_background()
    
    @help_window.update
    @battle_formation_details_window.update
    @party_order_window.update
    @command_window.update
    @battle_formations_window.update
    if @command_window.active
      update_command_selection()
    elsif @battle_formations_window.active
      update_change_selection()
    elsif @party_order_window.active
      update_order_selection()
    end
    
  end

  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Return scene
  #--------------------------------------------------------------------------
  def return_scene
    if @menu_index != nil
      $scene = Scene_Menu.new(@menu_index)
    else
      $scene = Scene_Map.new
    end
  end
  private :return_scene
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene input management methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update Command Selection
  #--------------------------------------------------------------------------
  def update_command_selection()
    if Input.trigger?(Input::B)
        Sound.play_cancel
        quit_command()
     
    elsif Input.trigger?(Input::C)
      case @command_window.index
      when 0  # Change
        Sound.play_decision
        change_command()
      when 1  # Order
        Sound.play_decision
        order_command()
      when 2  # Revert
        Sound.play_decision
        revert_command()
      end
    end
    
  end
  private :update_command_selection
  
  #--------------------------------------------------------------------------
  # * Update Change Selection
  #--------------------------------------------------------------------------
  def update_change_selection
    if Input.trigger?(Input::B)
      $game_party.battle_formation_index = @battle_formations_window.index
      
      Sound.play_cancel
      cancel_command()
    end
  end
  private :update_change_selection
  
  #--------------------------------------------------------------------------
  # * Update Order Selection
  #--------------------------------------------------------------------------
  def update_order_selection
    if Input.trigger?(Input::B)
      Sound.play_cancel
      cancel_command()
    elsif Input.trigger?(Input::C)
      
      if @party_order_window.nbr_selected_indexes == 2
        Sound.play_decision
        do_order_command()
      end
        
    end
  end
  private :update_order_selection
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene Commands
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Cancel command
  #--------------------------------------------------------------------------
  def cancel_command()
    @command_window.active = true
    @party_order_window.clean_indexes()
    @party_order_window.active = false
    @party_order_window.index = -1
    @battle_formations_window.active = false
    @battle_formation_details_window.window_update(nil)
    @battle_formation_details_window.visible = false
    @help_window.window_update("")
    @help_window.visible = true
  end
  private :cancel_command
  
  #--------------------------------------------------------------------------
  # * Change command
  #--------------------------------------------------------------------------
  def change_command()
    @command_window.active = false
    @battle_formations_window.active = true
    @battle_formations_window.call_update_help()
  end
  private :change_command
  
  #--------------------------------------------------------------------------
  # * Order command
  #--------------------------------------------------------------------------
  def order_command()
    @command_window.active = false
    @party_order_window.active = true
    @party_order_window.index = 0
  end
  private :order_command
  
  #--------------------------------------------------------------------------
  # * Revert command
  #--------------------------------------------------------------------------
  def revert_command()
    # Revert changes
    for i in 0 .. $game_party.members.size-1
      $game_party.actor_positions[i] = @actor_positions_backup[$game_party.members[i].id]
    end
    
    $game_party.battle_formation_index = @battle_formation_index_backup
    
    @battle_formations_window.index = $game_party.battle_formation_index
    @party_order_window.window_update($game_party.members)
    @battle_formations_window.window_update(PARTY_CONFIG::BATTLE_FORMATIONS)
  end
  private :revert_command
  
  #--------------------------------------------------------------------------
  # * Do Order command
  #--------------------------------------------------------------------------
  def do_order_command()
    change_done = false
    actor1 = @party_order_window.selected_actor(0)
    actor2 = @party_order_window.selected_actor(1)
    
    # Two empty spaces
    if actor1 == nil && actor2 == nil

      # Nothing to do, only refresh to remove the selected indexes
      change_done = true
      
    # Switch between an empty space and an actor
    elsif actor1 != nil && actor2 == nil
      
      $game_party.change_actor_position(actor1.id,@party_order_window.index(1))
      change_done = true
      
    # Switch between an empty space and an actor
    elsif actor1 == nil && actor2 != nil
      
      $game_party.change_actor_position(actor2.id,@party_order_window.index(0))
      change_done = true
      
    # Switch between two actors
    elsif actor1 != nil && actor2 != nil

      $game_party.change_actor_position(actor1.id,@party_order_window.index(1))
      $game_party.change_actor_position(actor2.id,@party_order_window.index(0))
      change_done = true
      
    end
      
    if change_done 
      @party_order_window.clean_indexes()
      @party_order_window.window_update($game_party.members)
      @battle_formations_window.window_update(PARTY_CONFIG::BATTLE_FORMATIONS)
    end
  end
  private :do_order_command
  
  #--------------------------------------------------------------------------
  # * Quit command
  #--------------------------------------------------------------------------
  def quit_command()
    return_scene
  end
  private :quit_command
  
end

#==============================================================================
# ** Font
#------------------------------------------------------------------------------
#  Contains the different fonts
#==============================================================================

class Font
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Battle Formation Details Stats Font
  #--------------------------------------------------------------------------
  def self.formation_details_stats_font
    f = Font.new()
    f.size = 12
    return f
  end
  
end

#==============================================================================
# ** Color
#------------------------------------------------------------------------------
#  Contains the different colors
#==============================================================================

class Color
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get HP Gauge Color 1
  #--------------------------------------------------------------------------
  def self.hp_gauge_color1
    return text_color(20)
  end
  
  #--------------------------------------------------------------------------
  # * Get HP Gauge Color 2
  #--------------------------------------------------------------------------
  def self.hp_gauge_color2
    return text_color(21)
  end
  
  #--------------------------------------------------------------------------
  # * Get MP Gauge Color 1
  #--------------------------------------------------------------------------
  def self.mp_gauge_color1
    return text_color(22)
  end
  
  #--------------------------------------------------------------------------
  # * Get MP Gauge Color 2
  #--------------------------------------------------------------------------
  def self.mp_gauge_color2
    return text_color(23)
  end
  
  #--------------------------------------------------------------------------
  # * Get Exp Gauge Color 1
  #--------------------------------------------------------------------------
  def self.exp_gauge_color1
    return text_color(14)
  end
  
  #--------------------------------------------------------------------------
  # * Get Exp Gauge Color 2
  #--------------------------------------------------------------------------
  def self.exp_gauge_color2
    return text_color(17)
  end

end

#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
#  This module defines terms and messages. It defines some data as constant
# variables. Terms in the database are obtained from $data_system.
#==============================================================================

module Vocab

  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #//////////////////////////////////////////////////////////////////////////
  # * Stats Parameters related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get HP Label
  #--------------------------------------------------------------------------
  def self.hp_label
    return self.hp
  end
  
  #--------------------------------------------------------------------------
  # * Get MP Label
  #--------------------------------------------------------------------------
  def self.mp_label
    return self.mp
  end
  
  #--------------------------------------------------------------------------
  # * Get ATK Label
  #--------------------------------------------------------------------------
  def self.atk_label
    return self.atk
  end
  
  #--------------------------------------------------------------------------
  # * Get DEF Label
  #--------------------------------------------------------------------------
  def self.def_label
    return self.def
  end
  
  #--------------------------------------------------------------------------
  # * Get SPI Label
  #--------------------------------------------------------------------------
  def self.spi_label
    return self.spi
  end
  
  #--------------------------------------------------------------------------
  # * Get AGI Label
  #--------------------------------------------------------------------------
  def self.agi_label
    return self.agi
  end
  
  #--------------------------------------------------------------------------
  # * Get EVA Label
  #--------------------------------------------------------------------------
  def self.eva_label
    return "EVA"
  end
  
  #--------------------------------------------------------------------------
  # * Get HIT Label
  #--------------------------------------------------------------------------
  def self.hit_label
    return "HIT"
  end
  
  #--------------------------------------------------------------------------
  # * Get CRI Label
  #--------------------------------------------------------------------------
  def self.cri_label
    return "CRI"
  end
  
  #--------------------------------------------------------------------------
  # * Get EXP Label
  #--------------------------------------------------------------------------
  def self.exp_label
    return "EXP"
  end
  
  #--------------------------------------------------------------------------
  # * Get Level Label
  #--------------------------------------------------------------------------
  def self.lvl_label
    return self.level
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Battle Formation Details Window related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Stats
  #--------------------------------------------------------------------------
  def self.stats_label
    return "STATS"
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # Scene Menu related
  #//////////////////////////////////////////////////////////////////////////
    
  #--------------------------------------------------------------------------
  # * Get Title to show in the menu for the Party Change Scene
  #--------------------------------------------------------------------------
  def self.party_menu_title
    return "Party"
  end
  
  #--------------------------------------------------------------------------
  # * Get Title to show in the menu for the Formation Change Scene
  #--------------------------------------------------------------------------
  def self.formation_menu_title
    return "Formation"
  end  
  
  #//////////////////////////////////////////////////////////////////////////
  # Scene Party related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get default help text in Party Change
  #--------------------------------------------------------------------------
  def self.party_help_text
    return "Form %d group(s)"
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show in the help window if there are empty groups
  #--------------------------------------------------------------------------
  def self.empty_parties_warning_text
    return "You need to form %d group(s)"
  end

  #--------------------------------------------------------------------------
  # * Get Text to show for Change command
  #--------------------------------------------------------------------------
  def self.party_change_command
    return "Change"
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show for Revert command
  #--------------------------------------------------------------------------
  def self.party_revert_command
    return "Revert"
  end  
  
  #--------------------------------------------------------------------------
  # * Get Text to show for Empty command
  #--------------------------------------------------------------------------
  def self.party_empty_command
    return "Empty group(s)"
  end  
  
  #//////////////////////////////////////////////////////////////////////////
  # Scene Formation related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Text to show for Change command
  #--------------------------------------------------------------------------
  def self.formation_change_command
    return "Change"
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show for Order command
  #--------------------------------------------------------------------------
  def self.formation_order_command
    return "Order"
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show for Revert command
  #--------------------------------------------------------------------------
  def self.formation_revert_command
    return "Revert"
  end 
  
  #--------------------------------------------------------------------------
  # * Get Strings to show for every battle formations (name + description)
  #--------------------------------------------------------------------------
  def self.battle_formations_strings
    return [
     ["Normal", "Default battle formation."],
     ["Corner", "Regroups party on one side, adding bonus to defense."],
     ["Arrow", "Regroups party like an arrow, adding bonus to attacks."],
     ["Parallel", "Large space within group, two in front, two in the back."]
    ]
  end
  
end

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

#==============================================================================
# ** Window_Status
#------------------------------------------------------------------------------
#  This window displays full status specs on the status screen.
#==============================================================================

class Window_Status < Window_Base
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set the actor object
  #     actor : Actor object
  #--------------------------------------------------------------------------
  # SET
  def actor=(actor)
    @actor = actor
  end
  
  #--------------------------------------------------------------------------
  # * Alias refresh
  #--------------------------------------------------------------------------
  alias refresh_ebjb refresh unless $@
  def refresh
    if @actor != nil
      refresh_ebjb
    end
  end
  
end

#==============================================================================
# ** Window_MenuStatus
#------------------------------------------------------------------------------
#  This window displays party member status on the menu screen.
#==============================================================================

class Window_MenuStatus < Window_Selectable
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update cursor
  #--------------------------------------------------------------------------
  def update_cursor
    if @index < 0               # No cursor
      self.cursor_rect.empty
    elsif @index < @item_max    # Normal
      self.cursor_rect.set(0, $game_party.actor_positions[@index] * 96, contents.width, 96)
    elsif @index >= 100         # Self
      self.cursor_rect.set(0, (@index - 100) * 96, contents.width, 96)
    else                        # All
      self.cursor_rect.set(0, 0, contents.width, @item_max * 96)
    end
  end
  
end

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

#==============================================================================
# ** Window_SaveFile
#------------------------------------------------------------------------------
#  This window displays save files on the save and load screens.
#==============================================================================

class Window_SaveFile < Window_Base
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw Party Characters
  #     x : Draw spot X coordinate
  #     y : Draw spot Y coordinate
  #--------------------------------------------------------------------------
  def draw_party_characters(x, y)
    for i in 0...@characters.size
      name = @characters[i][0]
      index = @characters[i][1]
      pos = @characters[i][2]
      draw_character(name, index, x + pos * 48, y)
    end
  end
  
end

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

