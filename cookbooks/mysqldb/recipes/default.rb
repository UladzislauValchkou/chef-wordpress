#
# Cookbook:: mysqldb
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

secret = Chef::EncryptedDataBagItem.load_secret("#{current_dir}/../.chef/encrypted_data_bag_secret")
creds = Chef::EncryptedDataBagItem.load("mysqlcreds", "sqlcreds", secret)

mysql_service 'db' do
  port '3306'
  bind_adress '192.168.56.20'
  version '5.5'
  initial_root_password "creds['adminpass']"
  action [:create, :start]
end

mysql_client 'default' do
  action :create
end

mysql2_chef_gem 'default' do
  action :install
end

mysql_database 'wordpress' do
  connection( 
    :host     => '192.168.56.20',
    :username => 'root',
    :password => creds['adminpass']
  )
  action :create
end

mysql_database_user 'wordpress' do
  connection(
    :host     => '192.168.56.20',
    :username => 'root',
    :password => creds['adminpass']
  )
  password      'creds['dbpass']'
  database_name 'wordpress'
  action        [:create, :grant]
end


