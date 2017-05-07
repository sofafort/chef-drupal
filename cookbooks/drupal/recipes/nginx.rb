package 'nginx'

# integrate pgp-fpm

  template '/etc/nginx/sites-available/default' do
  source 'nginx-drupal.erb'
  owner 'root'
  group 'root'
  mode 00644
end

service 'nginx' do
  action [:enable, :start]
end
