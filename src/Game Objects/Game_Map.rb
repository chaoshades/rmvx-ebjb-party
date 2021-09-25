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
