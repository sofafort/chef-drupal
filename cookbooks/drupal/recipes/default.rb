#
# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#

include_recipe 'drupal::nginx'
include_recipe 'drupal::postgresql'
include_recipe 'drupal::php'
include_recipe 'drupal::composer'
include_recipe 'drupal::drush'
