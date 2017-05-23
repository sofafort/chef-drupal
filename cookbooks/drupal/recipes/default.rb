#
# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#

execute 'do-release-upgrade' do
  command 'do-release-upgrade -d -f DistUpgradeViewNonInteractive'
  action :run
  only_if { node[:platform] == 'ubuntu'  && (node[:platform_version]).to_f < 14.04 }
end

package 'git'

include_recipe 'drupal::nginx'
include_recipe 'drupal::postgresql'
include_recipe 'drupal::php'
include_recipe 'drupal::composer'
include_recipe 'drupal::drush'

bash 'copy_ssh_files' do
  user 'vagrant'
  cwd '/vagrant'
  code <<-EOH
  cp -r .ssh/ ~/
  chmod 700 ~/.ssh
  chmod 600 ~/.ssh/*
  cp .gitconfig ~/
  EOH
end

git "/vagrant/" + node.default['drupal']['project-name'] do
  repository "git@github.com/sofafort/" + node.default['drupal']['project-name'] + ".git"
  action :sync
end
