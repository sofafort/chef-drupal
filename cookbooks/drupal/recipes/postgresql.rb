package 'postgresql'

template '/etc/postgresql/9.5/main/pg_hba.conf' do
  source 'pg_hba.conf.erb'
  owner 'postgres'
  group 'postgres'
  mode 00640
end

service 'postgresql' do
  action [:enable, :start]
end

execute 'create_database' do
  command 'createdb drupal-core; touch .drupal-core.created'
  action :run
  user 'postgres'
  cwd '/var/lib/postgresql'
  creates '.drupal-core.created'
end

#U=drupal; P=drupal_pass; echo -n md5; echo -n $P$U | md5sum | cut -d' ' -f1

execute 'add_drupal_user' do
  command 'psql -c "CREATE ROLE drupal WITH PASSWORD \'md5de2ecded3cd892ad10073b79abce2cec\' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;"; touch .drupal-user.created'
  action :run
  user 'postgres'
  cwd '/var/lib/postgresql'
  creates '.drupal-user.created'
end

execute 'alter_bytea_output' do
  command 'psql -c "ALTER DATABASE \"drupal-core\" SET bytea_output = \'escape\';"'
  action :run
  user 'postgres'
  cwd '/var/lib/postgresql'
  creates '.bytea_output.altered'
end
