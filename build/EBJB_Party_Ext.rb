#==============================================================================
#  Multiple Parties
#  Version: 1.0b
#  Author: modern algebra (rmrk.net)
#  Date: April 2, 2008
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Description:
#    This script allows you to maintain multiple parties (separate item lists, steps,
#    everything) and allows you to merge them at will. Primarily useful for a 
#    game where parties split up or a game where you can have separate parties
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Instructions:
#    Place this script under ? Materials in the Script Editor.
#    There are several codes to keep in mind:
#
#      $game_parties[id]                :accesses the party located in that index.
#                                       :creates it if it does not yet exist.
#      $game_parties[id] = X            :Sets the party to X. It MUST be a  
#                                       :Game_Party object
#      p = $game_parties.merge(id1,id2) :merges two parties and saves them in p
#      $game_parties.merge! (id1, id2)  :merges two parties and saves them in 
#                                       :$game_parties[id1] and deletes $game_parties[id2]
#      $game_parties.delete (id)        :Deletes $game_parties[id]
#
#    In order to switch the current party, just do this:
#
#      $game_party = $game_parties[id]
#      $game_player.refresh
#
#    By default, the original party is saved in $game_parties[0], so you may
#    want to avoid overwriting $game_parties[0] and just work with 1,2,...
#
#    Also, be very careful when dealing with parties. Always remember what
#    parties exist and where they are in $game_parties or else you may make a
#    stupid error occur.
#
#        *EXAMPLE EVENT*
#
#      @>Change Items: [Potion], + 1
#      @>Change Gold: + 50
#      @>Script: p = $game_parties[1]
#       :      : $game_party = p
#       :      : $game_player.refresh
#      @>Change Party Member: Add [Oscar], Initialize
#      @>Change Weapons: [Bastard Sword], +1
#      @>Change Gold: + 100
#
#    Assuming that $game_parties[1] did not previously exist, this event just
#    switched your party to the party with index 1, and if you looked at your
#    menu you would see that Oscar is in the party, you have 100 Gold, and a
#    Bastard Sword. The potion and the other 50 Gold went to the initial party
#
#    Now, let's say Oscar later meets up with his party and rejoins. Then this
#    event would do the trick:
#
#      @>Script: $game_parties.merge! (0, 1)
#       :      : $game_party = $game_parties[0]
#       :      : $game_player.refresh
#
#    And there, the two parties have been merged and everything that Oscar had
#    obtained goes to the party.
#==============================================================================

#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  Summary of Changes:
#    new method - add_multiple_steps
#==============================================================================

class Game_Party < Game_Unit
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Add Multiple Steps
  #    amount : the amount of steps to add
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def add_multiple_steps (amount)
    @steps += amount
  end
end

#==============================================================================
# ** Game_Parties
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  This class handles Parties. It's a wrapper for the built-in class "Array."
#  It is accessed by $game_parties
#==============================================================================

class Game_Parties
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Object Initialization
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def initialize
    @data = [$game_party]
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Retrieve Party
  #    id : the ID of the party
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def [] (id)
    @data[id] = Game_Party.new if @data[id] == nil
    return @data[id]
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Set Party
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def []= (id, party)
    # Does nothing unless it is a party object
    return unless party.class == Game_Party
    @data[id] = party
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Merge 
  #    id_1 : the ID of the first party
  #    id_2 : the ID of the second party
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def merge (id_1, id_2)
    new_party = Game_Party.new
    # Get old parties
    op1 = self[id_1]
    op2 = self[id_2]
    # Gold
    new_party.gain_gold (op1.gold + op2.gold)
    # Members
    (op1.members | op2.members).each { |actor| new_party.add_actor (actor.id) }
    # Items, Weapons, and Armor
    (op1.items | op2.items).each { |item|
      new_party.gain_item (item, op1.item_number (item) +  op2.item_number (item))
    }
    # Steps 
    new_party.add_multiple_steps (op1.steps + op2.steps)
    # Last Item
    new_party.last_item_id = op1.last_item_id
    # Last Actor
    new_party.last_actor_index = op1.last_actor_index
    # Last Target
    new_party.last_target_index = op1.last_target_index
    # Quests (if game includes my Quest Log)
    begin
      (op1.quests.list | op2.quests.list).each { |quest|
        new_quest = new_party.quests[quest.id]
        # Reveal Objectives
        quest.revealed_objectives.each { |i| new_quest.reveal_objective (i) }
        # Complete Objectives
        quest.complete_objectives.each { |i| new_quest.complete_objective (i) }
        # Fail Objectives
        quest.failed_objectives.each { |i| new_quest.fail_objective (i) }
        # Concealed?
        new_quest.concealed = quest.concealed
        # Reward Given?
        new_quest.reward_given = quest.reward_given
      }
    rescue
    end
    return new_party
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Merge! 
  #    id_1 : the ID of the first party to which the second party is merged
  #    id_2 : the ID of the second party that is deleted 
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def merge! (id_1, id_2)
    @data[id_1] = merge (id_1, id_2)
    delete (id_2)
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Delete
  #     id : the ID of the quest to be deleted
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def delete (id)
    @data[id] = nil
    # If this was the last in the array
    if id == @data.size - 1
      # Delete any nil elements that exist between this party and its successor
      id -= 1
      while @data[id] == nil
        @data.delete (id)
        id -= 1
      end
    end
  end
end

#~ #==============================================================================
#~ # ** Scene_Title
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~ #  Summary of Changes:
#~ #    aliased method - create_game_objects
#~ #==============================================================================

#~ class Scene_Title < Scene_Base
#~   #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~   # * Create Game Objects
#~   #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~   alias modalg_multiparty_crt_gme_objcs_5som create_game_objects
#~   def create_game_objects
#~     modalg_multiparty_crt_gme_objcs_5som
#~     $game_parties      = Game_Parties.new
#~   end
#~ end

#~ #==============================================================================
#~ # ** Scene_File
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~ #  Summary of Changes:
#~ #    aliased methods - read_save_data, write_save_data
#~ #==============================================================================

#~ class Scene_File
#~   
#~   #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~   # * Write Save Data
#~   #     file : write file object (opened)
#~   #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~   alias modalg_multiparty_wrt_sv_dta_6hye write_save_data
#~   def write_save_data(file)
#~     modalg_multiparty_wrt_sv_dta_6hye (file)
#~     Marshal.dump($game_parties,        file)
#~   end
#~   #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~   # * Read Save Data
#~   #     file : file object for reading (opened)
#~   #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~   alias modalg_multiparty_rd_sv_dat_2gte read_save_data
#~   def read_save_data(file)
#~     modalg_multiparty_rd_sv_dat_2gte (file)
#~     $game_parties        = Marshal.load(file)
#~   end
#~ end

