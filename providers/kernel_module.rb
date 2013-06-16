class Chef::Provider
  include KernelModule
end

action :enable do
  module_name = @new_resource.name

  # Add to /boot/loader.conf
  Chef::Log.info "Enabling kernel module #{module_name}"
  lines = read_loader_conf
  lines.delete_if { |line| line =~ /^#{Regexp.escape(module_name)}_load/ }
  lines << "#{module_name}_load=\"YES\""
  write_loader_conf(lines)

  # Enable the module
  unless kernel_module_enabled?(module_name)
    Chef::Log.info "Loading kernel module #{module_name}"
    load_kernel_module(module_name)
  end

  new_resource.updated_by_last_action(true)
end

action :disable do
  module_name = @new_resource.name

  # Remove from /boot/loader.conf
  Chef::Log.info "Disabling kernel module #{module_name}"
  lines = read_loader_conf
  lines.delete_if { |line| line =~ /^#{Regexp.escape(module_name)}_load/ }
  write_loader_conf(lines)

  # Unload the module
  if kernel_module_enabled?(module_name)
    Chef::Log.info "Unloading kernel module #{module_name}"
    unload_kernel_module(module_name)
  end

  new_resource.updated_by_last_action(true)
end

private

def load_kernel_module(name)
  cmd = Mixlib::ShellOut.new("kldload #{name}")
  cmd.run_command
  cmd.error!
end

def unload_kernel_module(name)
  cmd = Mixlib::ShellOut.new("kldunload #{name}")
  cmd.run_command
  cmd.error!
end

def read_loader_conf
  ::File.open("/boot/loader.conf", 'r') { |file| file.readlines }
end

def write_loader_conf(lines)
  ::File.open("/boot/loader.conf", 'w') do |file|
    lines.each { |line| file.puts(line) }
  end
end
