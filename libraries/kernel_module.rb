module KernelModule
  def kernel_module_enabled?(name)
    cmd = Mixlib::ShellOut.new("kldstat")
    cmd.run_command
    cmd.error!
    cmd.stdout.include?("#{name}.ko")
  end
end
