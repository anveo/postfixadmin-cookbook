
def whyrun_supported?
  true
end

action :create do
  new_resource = @new_resource
  address = new_resource.name
  username, domain = address.split('@', 2)
  if domain.nil?
    raise Chef::Exceptions::ArgumentError, 'Could not get the domain name from the address argument, it should have the following format: user@domain.tld'
  end
  goto = new_resource.goto
  active = new_resource.active
  login_username = new_resource.login_username
  login_password = new_resource.login_password
  db_adapter = new_resource.db_adapter || node['postfixadmin']['database']['adapter']
  db_user = new_resource.db_user || node['postfixadmin']['database']['user']
  db_password = new_resource.db_password || node['postfixadmin']['database']['password']
  db_name = new_resource.db_name || node['postfixadmin']['database']['name']
  db_host = new_resource.db_host || node['postfixadmin']['database']['host']
  db_port = new_resource.db_port || node['postfixadmin']['database']['port']
  ssl = new_resource.ssl || node['postfixadmin']['ssl']

  converge_by("Create #{new_resource}") do
    db = PostfixAdmin::DB.new(db_adapter, db_user, db_password, db_name, db_host, db_port)
    ruby_block "create alias #{address}" do
      block do
        result = PostfixAdmin::API.createAlias(username, domain, goto, active, login_username, login_password, ssl)
        Chef::Log.info("Created #{new_resource}: #{result}")
      end
      not_if do db.aliasExists?(address) end
      action :create
    end
  end

end

