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
