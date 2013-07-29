
def whyrun_supported?
  true
end

action :create do
  new_resource = @new_resource
  user = new_resource.user
  setup_password = new_resource.setup_password || node['postfixadmin']['setup_password']
  db_adapter = new_resource.db_adapter || node['postfixadmin']['database']['adapter']
  db_user = new_resource.db_user || node['postfixadmin']['database']['user']
  db_password = new_resource.db_password || node['postfixadmin']['database']['password']
  db_name = new_resource.db_name || node['postfixadmin']['database']['name']
  db_host = new_resource.db_host || node['postfixadmin']['database']['host']
  db_port = new_resource.db_port || node['postfixadmin']['database']['port']
  ssl = new_resource.ssl || node['postfixadmin']['ssl']

  converge_by("Create #{new_resource}") do
    db = PostfixAdmin::DB.new(db_adapter, db_user, db_password, db_name, db_host, db_port)
    ruby_block "create admin user #{user}" do
      block do
        result = PostfixAdmin::API.createAdmin(user, new_resource.password, setup_password, ssl)
        Chef::Log.info("Created #{new_resource}: #{result}")
      end
      not_if do db.adminExists?(user) end
      action :create
    end
  end

end

action :remove do
  new_resource = @new_resource
  user = new_resource.user
  db_adapter = new_resource.db_adapter || node['postfixadmin']['database']['adapter']
  db_user = new_resource.db_user || node['postfixadmin']['database']['user']
  db_password = new_resource.db_password || node['postfixadmin']['database']['password']
  db_name = new_resource.db_name || node['postfixadmin']['database']['name']
  db_host = new_resource.db_host || node['postfixadmin']['database']['host']
  db_port = new_resource.db_port || node['postfixadmin']['database']['port']

  converge_by("Remove #{new_resource}") do
    db = PostfixAdmin::DB.new(db_adapter, db_user, db_password, db_name, db_host, db_port)
    ruby_block "remove admin user #{user}" do
      block do
        deleted = db.removeAdmin(user)
        Chef::Log.info("Deleted #{new_resource}") if deleted
      end
      only_if do db.adminExists?(user) end
      action :create
    end
  end

end

