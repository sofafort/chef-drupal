execute 'add_drush_to_composer' do
  command 'composer require --prefer-dist --update-no-dev drush/drush'
  action :run
  creates '/home/drupal/vendor/drush/drush/drush'
  user 'drupal'
  cwd '/home/drupal'
end

directory '/home/drupal/projects' do
  owner 'drupal'
  group 'drupal'
  mode 00775
  recursive true
  action :create
end

execute 'download_drupal' do
    command '/home/drupal/vendor/drush/drush/drush dl drupal --drupal-project-rename=' + node["drupal"]["project-name"] + ' --destination=/home/drupal' ##/projects'
  action :run
  user 'drupal'
  creates '/home/drupal/' + node["drupal"]["project-name"]
end

execute 'chown_files_drupal' do
  command "chown -R drupal:drupal /home/drupal/" + node["drupal"]["project-name"]
  not_if { ::File.exist?('/home/drupal/' + node["drupal"]["project-name"] + '/.site-permissions') }
end

execute 'chmod_files_drupal' do
  command "chmod -R g+w /home/drupal/" + node["drupal"]["project-name"]
  not_if { ::File.exist?('/home/drupal/' + node["drupal"]["project-name"] + '/.site-permissions') }
end

execute 'install_site' do
  command '/home/drupal/vendor/drush/drush/drush site-install standard --db-url=\'pgsql://drupal:drupal_pass@localhost/drupal-core\' --site-name=' + node["drupal"]["project-name"] + ' --account-name=admin --account-pass=admin123 --yes && touch .site-installed'
  action :run
  cwd '/home/drupal/' + node["drupal"]["project-name"]
  user 'drupal'
  notifies :restart, "service[nginx]", :delayed
  creates '/home/drupal/' + node["drupal"]["project-name"]+ '/.site-installed'
end

execute 'chown_files_www-data' do
  command "chown -R www-data:www-data /home/drupal/" + node['drupal']['project-name'] + "/sites/default && touch /home/drupal/" + node['drupal']['project-name'] + "/.site-permissions"
  creates '/home/drupal/' + node["drupal"]["project-name"] + '/.site-permissions'
end

execute 'update_sync_directory' do
  command "/home/drupal/vendor/drush/drush/drush $config_directories[CONFIG_SYNC_DIRECTORY] = '/vagrant/" + node['drupal']['project-name'] + "';"
  action :run
  user 'drupal'
end
