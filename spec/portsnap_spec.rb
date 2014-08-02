require 'spec_helper'

describe 'freebsd::portsnap' do
  let(:chef_run) do
    ChefSpec::Runner.new(
      :platform => 'freebsd',
      :version => '10.0'
      ).converge('freebsd::portsnap')
  end

  context 'compiling the recipe' do
    it 'runs a script' do
      expect(chef_run).to run_script('create non-interactive portsnap')
    end
    
  end
end
