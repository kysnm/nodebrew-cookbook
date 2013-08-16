# Cookbook Name:: nodebrew
# Provider:: node

include Chef::Mixin::Nodebrew

action :install do
  case
  when nodebrew_missing?
    Chef::Log.warn 'Nodebrew is missing. Action will be skipped.'
  when node_installed?(new_resource.version)
    Chef::Log.info "#{new_resource} is already installed - nothing to do"
  else
    Chef::Log.info "Building #{new_resource}, this could take a while..."
    install_start = Time.now

    install = 'install'
    install << '-binary' if new_resource.binary
    command = "nodebrew #{install} #{new_resource.version}"

    nodebrew_script command do
      action :nothing
      code command
    end.run_action(:run)

    install_time = (Time.now - install_start) / 60.0
    Chef::Log.info "#{new_resource} build time was #{install_time} minutes"

    new_resource.updated_by_last_action(true)
  end
end
