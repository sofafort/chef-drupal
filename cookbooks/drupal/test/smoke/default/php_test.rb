%w{libpq-dev libxml2-dev make}.each do |pkg|
  describe package pkg do
    it {should be_installed}
  end
end

describe apache_conf('/etc/nginx/sites-available/default') do
  its ('index') {should match ['index.php index.html index.htm;']}
  its ('location') { should include '~* \.php$ {'}
  its ('content') {should match 'index.php'}
  its ('fastcgi_pass') {should include '127.0.0.1:9000;'}
  its ('include') {should include 'fastcgi_params;'}
  its ('fastcgi_param') {should match ["SCRIPT_FILENAME    $document_root$fastcgi_script_name;", "SCRIPT_NAME        $fastcgi_script_name;"]}
end

#describe parse_config_file('/usr/local/php/php.ini') do
#  its ('cgi'+ '.' + 'fix_pathinfo') {should eq 0}
#end

describe port(9000) do
  it { should be_listening }
end
