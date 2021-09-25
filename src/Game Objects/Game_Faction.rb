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
