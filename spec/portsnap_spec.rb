require 'spec_helper'

describe 'freebsd::portsnap' do
  let(:chef_runner) { ChefSpec::Runner.new }
  let(:chef_run) { chef_runner.converge(described_recipe) }
  let(:node) { chef_runner.node }
  before do
    orig_file_exist = ::File.method(:exist?)
    allow(::File).to receive(:exist?) { |*args| orig_file_exist.call(*args) }
  end

  it 'Compile Time should be disabled by default' do
    chef_run
    expect(node['freebsd']['compiletime']).to be(false)
  end

  context 'on FreeBSD 9' do
    let(:chef_runner) { ChefSpec::Runner.new(platform: 'freebsd', version: '9.2') }
    let(:portsnap_bin) { File.join(Chef::Config[:file_cache_path], 'portsnap') }
    let(:portsnap_options) { '' }

    it 'runs create non-interactive portsnap script' do
      expect(chef_run).to run_script('create non-interactive portsnap')
        .at_converge_time
    end

    it 'runs portsnap update' do
      expect(chef_run).to run_execute("#{portsnap_bin} update ")
        .at_converge_time
    end

    context 'when portsnap index exists' do
      before do
        allow(::File).to receive(:exist?).with('/usr/ports/.portsnap.INDEX')
          .and_return(true)
      end

      it 'does not run portsnap fetch and extract' do
        expect(chef_run).to_not run_execute("#{portsnap_bin} fetch extract ")
      end
    end # context portsnap index exists

    context 'when portsnap does not exist' do
      before do
        allow(::File).to receive(:exist?).with('/usr/ports/.portsnap.INDEX')
          .and_return(false)
      end

      it 'runs portsnap fetch and extract' do
        expect(chef_run).to run_execute("#{portsnap_bin} fetch extract ")
          .at_converge_time
      end
    end # context portsnap index not exist

  end # context on FreeBSD 9

  context 'on FreeBSD 10' do
    let(:chef_runner) { ChefSpec::Runner.new(platform: 'freebsd', version: '10.0') }
    let(:portsnap_bin) { 'portsnap' }
    let(:portsnap_options) { '--interactive' }

    it 'does not run create non-interactive portsnap script' do
      expect(chef_run).to_not run_script('create non-interactive portsnap')
    end

    it 'runs portsnap update in interactive mode' do
      expect(chef_run).to run_execute("#{portsnap_bin} update --interactive")
        .at_converge_time
    end

    context 'when portsnap index exists' do
      before do
        allow(::File).to receive(:exist?).with('/usr/ports/.portsnap.INDEX')
          .and_return(true)
      end

      it 'does not run portsnap fetch and extract' do
        expect(chef_run).to_not run_execute("#{portsnap_bin} fetch extract #{portsnap_options}")
      end
    end # context portsnap index exists

    context 'when portsnap does not exist' do
      before do
        allow(::File).to receive(:exist?).with('/usr/ports/.portsnap.INDEX')
          .and_return(false)
      end

      it 'runs portsnap fetch and extract' do
        expect(chef_run).to run_execute("#{portsnap_bin} fetch extract #{portsnap_options}")
          .at_converge_time
      end
    end # context portsnap index not exist

  end # context on FreeBSD 10

  context 'with Compile Time' do
    before { node.set['freebsd']['compiletime'] = true }

    context 'on FreeBSD 9' do
      let(:chef_runner) { ChefSpec::Runner.new(platform: 'freebsd', version: '9.2') }
      let(:portsnap_bin) { File.join(Chef::Config[:file_cache_path], 'portsnap') }
      let(:portsnap_options) { '' }

      it 'runs create non-interactive portsnap script' do
        expect(chef_run).to run_script('create non-interactive portsnap')
          .at_compile_time
      end

      it 'runs portsnap update' do
        expect(chef_run).to run_execute("#{portsnap_bin} update #{portsnap_options}")
          .at_compile_time
      end

      context 'when portsnap index exists' do
        before do
          allow(::File).to receive(:exist?).with('/usr/ports/.portsnap.INDEX')
            .and_return(true)
        end

        it 'does not run portsnap fetch and extract' do
          expect(chef_run).to_not run_execute("#{portsnap_bin} fetch extract ")
        end
      end # context portsnap index exists

      context 'when portsnap does not exist' do
        before do
          allow(::File).to receive(:exist?).with('/usr/ports/.portsnap.INDEX')
            .and_return(false)
        end

        it 'runs portsnap fetch and extract' do
          expect(chef_run).to run_execute("#{portsnap_bin} fetch extract ")
            .at_compile_time
        end
      end # context portsnap index not exist

    end # context on FreeBSD 9

    context 'on FreeBSD 10' do
      let(:chef_runner) { ChefSpec::Runner.new(platform: 'freebsd', version: '10.0') }
      let(:portsnap_bin) { 'portsnap' }
      let(:portsnap_options) { '--interactive' }

      it 'runs portsnap update in interactive mode' do
        expect(chef_run).to run_execute("#{portsnap_bin} update --interactive")
          .at_compile_time
      end

      context 'when portsnap index exists' do
        before do
          allow(::File).to receive(:exist?).with('/usr/ports/.portsnap.INDEX')
            .and_return(true)
        end

        it 'does not run portsnap fetch and extract' do
          expect(chef_run).to_not run_execute("#{portsnap_bin} fetch extract #{portsnap_options}")
        end
      end # context portsnap index exists

      context 'when portsnap does not exist' do
        before do
          allow(::File).to receive(:exist?).with('/usr/ports/.portsnap.INDEX')
            .and_return(false)
        end

        it 'runs portsnap fetch and extract' do
          expect(chef_run).to run_execute("#{portsnap_bin} fetch extract #{portsnap_options}")
            .at_compile_time
        end
      end # context portsnap index not exist

    end # context on FreeBSD 10

  end # context with Compile Time
end
