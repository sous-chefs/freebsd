describe file('/etc/pkg/FreeBSD.conf') do
  it { should be_file }
end

# Verify PKGNG is installed
describe file('/usr/sbin/pkg') do
  it { should be_file }
  it { should be_executable }
end

describe command('pkg query %n pkg') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should eq("pkg\n") }
end

describe file('/etc/make.conf') do
  it { should be_file }
  it { should contain 'WITH_PKGNG' }
end
