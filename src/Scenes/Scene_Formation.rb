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
