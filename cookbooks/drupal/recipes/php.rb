
#package 'libpq-dev'
#package 'libxml2-dev'
#package 'make'
#package 'openssl'

#%w{libpq-dev libxml2-dev make openssl pkg-config libssl-dev libsslcommon2-dev libcurl4-openssl-dev}.each do |pkg|
#  package pkg
#end

#remote_file "#{Chef::Config[:file_cache_path]}/php-" + node['php']['version'] + '.tar.gz' do
#  source 'http://uk1.php.net/get/php-' + node['php']['version'] + '.tar.gz/from/this/mirror'
#  action :create_if_missing
#end

#directory "#{Chef::Config[:file_cache_path]}/php-" + node['php']['version']

#execute 'extract_php_tar' do
  #command "tar -xzvf #{Chef::Config[:file_cache_path]}/php-" + node['php']['version'] + ".tar.gz -C #{Chef::Config[:file_cache_path]}/php-" + node['php']['version']
#  creates "#{Chef::Config[:file_cache_path]}/php-" + node['php']['version'] + '/php-' + node['php']['version']
#end

#execute 'configure_php' do
  #command './configure --enable-fpm --with-pgsql --with-openssl-dir=/usr/local'
#  cwd "#{Chef::Config[:file_cache_path]}/php-" + node['php']['version'] + '/php-' + node['php']['version']
#  creates "#{Chef::Config[:file_cache_path]}/php-" + node['php']['version'] + '/php-' + node['php']['version'] + '/Makefile'
#end

#execute 'make_php' do
#  command 'make && touch .made'
#  cwd "#{Chef::Config[:file_cache_path]}/php-" + node['php']['version'] + '/php-' + node['php']['version']
#  creates "#{Chef::Config[:file_cache_path]}/php-" + node['php']['version'] + '/php-' + node['php']['version'] + '/.made'
#end

#execute 'make_install_php' do
#  command 'sudo make install'
#  cwd "#{Chef::Config[:file_cache_path]}/php-" + node['php']['version'] + '/php-' + node['php']['version']
#  creates '/usr/local/bin/php'
#end

#bash 'copy_config_files' do
#  code <<-EOL
#  cp sapi/fpm/php-fpm /usr/local/bin
#  EOL
#  cwd "#{Chef::Config[:file_cache_path]}/php-" + node['php']['version'] + '/php-' + node['php']['version']
#  creates '/usr/local/bin/php-fpm'
#end

case node[:platform]
when 'centos'
  %w{php7.0 php7.0-xml php7.0-pgsql php7.0-gd}.each do |pkg|
    package pkg
  end
when 'ubuntu'
  %w{php5 php5-xml php5-pgsql php5-gd}.each do |pkg|
    package pkg
  end
end

#template '/usr/local/php/php.ini' do
#  source 'php.ini.erb'
#  owner 'root'
#  group 'root'
#  mode 00644
#end

template '/usr/local/etc/php-fpm.conf' do
  source 'php-fpm.conf.erb'
  owner 'root'
  group 'root'
  mode 00644
end

template '/etc/init.d/php-fpm' do
  source 'init.d.php-fpm.erb'
  owner 'root'
  group 'root'
  mode 00755
end

service 'php-fpm' do
  action [:enable, :start]
end
