execute 'add_drush_to_composer' do
  command 'composer require drush/drush'
  action :run
  creates '/home/drupal/vendor/drush/drush/drush'
  user 'drupal'
  cwd '/home/drupal'
end

execute 'download_drupal' do
  command '/home/drupal/vendor/drush/drush/drush dl drupal --drupal-project-rename=node["drupal"]["project-name"] --destination=/home/drupal/projects'
  action :run
  user 'drupal'
  creates '/home/drupal/projects/node["drupal"]["project-name"]'
end

execute 'chmod_files_drupal' do
  command "chown -R drupal:root /home/drupal/projects/node['drupal']['project-name']/sites/default"
  not_if { ::File.exist?('/home/drupal/projects/node["drupal"]["project-name"]/.site-permissions') }
end

execute 'install_site' do
  command '/home/drupal/vendor/drush/drush/drush site-install standard --db-url=\'pgsql://drupal:drupal_pass@localhost/drupal-core\' --site-name= --account-name=admin --account-pass=admin123 --yes && touch .site-installed'
  action :run
  cwd '/home/drupal/projects/node["drupal"]["project-name"]'
  user 'drupal'
  notifies :restart, "service[nginx]", :delayed
  creates '/home/drupal/projects/node["drupal"]["project-name"]/.site-installed'
end

execute 'chmod_files_www-data' do
  command "chown -R www-data:www-data /home/drupal/projects/node['drupal']['project-name']/sites/default && touch /home/drupal/projects/node['drupal']['project-name']/.site-permissions"
  creates '/home/drupal/projects/node["drupal"]["project-name"]/.site-permissions'
end
