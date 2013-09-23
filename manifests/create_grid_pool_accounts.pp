# Class: site::create_grid_pool_accounts
#
# This module creates grid pool accounts and groups
#
# Parameters:
# $grid_groups a hash containing the pool_group parameters: {cms => {gid =>
# 700}, alice => {gid => 705}}
# $grid_accounts a hash containing the grid_pool_accounts parameters :
# {cms => {account_number_start => '001',
#          account_number_end => '010',
#           user_ID_number_start    = 70000,
#           user_ID_number_end    = 70010,
#         primary_group => 'cms'
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class site::create_grid_pool_accounts (
  $grid_groups            = {
  }
  ,
  $grid_accounts          = {
  }
  ,
  $create_home_directories = true,) {
  create_resources('grid_pool_accounts::pool_group', $grid_groups)
  $defaults = {
    'manage_home' => $create_home_directories,
  }
  create_resources('grid_pool_accounts', $grid_accounts, $defaults)

}