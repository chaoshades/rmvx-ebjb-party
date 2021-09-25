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
