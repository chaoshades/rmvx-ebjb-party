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
