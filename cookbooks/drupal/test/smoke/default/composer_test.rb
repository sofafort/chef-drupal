#describe file("#{Chef::Config[:file_cache_path]}/composer-setup.php") do
#  it {should be_file}
#  its('sha384sum') { should eq '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410' }
#end

describe file("/usr/local/php/composer.phar") do
  it {should be_file}
end
