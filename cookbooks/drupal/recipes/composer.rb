group 'drupal' do
  action :create
end

user 'drupal' do
  comment 'Drupal User'
  gid 'drupal'
  shell '/bin/bash'
  manage_home true
end

group 'drupal' do
  members 'www-data'
  action :modify
   append true
end

group 'www-data' do
  members 'drupal'
  action :modify
  append true
end

group 'sudo' do
  members 'drupal'
  action :modify
  append true
end

execute 'download_composer_installer' do
  command 'php -r "copy(\'https://getcomposer.org/installer\', \'composer-setup.php\');"'
  creates 'composer-setup.php'
  cwd "/home/drupal"
  user 'drupal'
end

execute 'check_composer_installer' do
  command 'php -r "if (hash_file(\'SHA384\', \'composer-setup.php\') === \'669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410\') { return 0; } else { return 1; }"; touch composer-setup.checked'
  creates 'composer-setup.checked'
  cwd "/home/drupal"
  user 'drupal'
end

execute 'run_composer_installer' do
  command 'export COMPOSER_HOME=/home/drupal; php composer-setup.php'
  creates "/home/drupal/composer.phar"
  cwd "/home/drupal"
  user 'drupal'
end

execute 'copy_phar_file' do
  command "cp /home/drupal/composer.phar /usr/local/bin/composer"
  creates '/usr/local/bin/composer'
end
