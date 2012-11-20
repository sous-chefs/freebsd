action :set do
  set_sysctl(@new_resource.name, @new_resource.value)

  new_resource.updated_by_last_action(true)
end

def load_current_resource
  @current_resource = Chef::Resource::FreebsdSysctl.new(@new_resource.name)
  @current_resource.value(@new_resource.value)

  @current_resource
end

private

def set_sysctl(name, value)
  if value.is_a?(TrueClass) || value.is_a?(FalseClass)
    value = ( value == true ) ? "1" : "0"
  else
    value = value.to_s
  end

  Chef::Log.info "Setting sysctl #{name} to #{value}"
  cmd = Mixlib::ShellOut.new("sysctl -w #{name}='#{value}'")
  cmd.run_command
  cmd.error!
end
