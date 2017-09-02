require 'spec_helper'

describe 'freebsd::portsnap' do
  let(:chef_runner) { ChefSpec::ServerRunner.new }
  let(:chef_run) { chef_runner.converge(described_recipe) }
  let(:node) { chef_runner.node }
  before { allow(::File).to receive(:exist?).and_call_original }

  it 'Compile Time should be disabled by default' do
    chef_run
    expect(node['freebsd']['compiletime_portsnap']).to be(false)
  end

  context 'on FreeBSD 10' do
    let(:chef_runner) { ChefSpec::ServerRunner.new(platform: 'freebsd', version: '10.3') }
    let(:portsnap_bin) { 'portsnap' }
    let(:portsnap_options) { '--interactive' }

    it 'does not generate a patched portsnap bin' do
      expect(chef_run).to_not run_script('create non-interactive portsnap')
    end

    it 'updates the extracted ports tree with the patched portsnap bin' do
      expect(chef_run).to run_execute("#{portsnap_bin} update #{portsnap_options}")
        .at_converge_time
    end

    context 'when the ports tree is already extracted' do
      before do
        allow(::File).to receive(:exist?).with('/usr/ports/.portsnap.INDEX')
                                         .and_return(true)
      end

      it 'does not fetch and extract' do
        expect(chef_run).to_not run_execute("#{portsnap_bin} fetch extract #{portsnap_options}")
      end
    end # context when the ports tree is already extracted

    context 'when the ports tree is not extracted' do
      before do
        allow(::File).to receive(:exist?).with('/usr/ports/.portsnap.INDEX')
                                         .and_return(false)
      end

      it 'fetches and extracts with the patched portsnap bin' do
        expect(chef_run).to run_execute("#{portsnap_bin} fetch extract #{portsnap_options}")
          .at_converge_time
      end
    end # context when the ports tree is not extracted
  end # context on FreeBSD 10

  context 'with Compile Time' do
    before { node.normal['freebsd']['compiletime_portsnap'] = true }

    context 'on FreeBSD 10' do
      let(:chef_runner) { ChefSpec::ServerRunner.new(platform: 'freebsd', version: '10.3') }
      let(:portsnap_bin) { 'portsnap' }
      let(:portsnap_options) { '--interactive' }

      it 'updates the extracted ports tree with the patched portsnap bin' do
        expect(chef_run).to run_execute("#{portsnap_bin} update #{portsnap_options}")
          .at_compile_time
      end

      context 'when the ports tree is already extracted' do
        before do
          allow(::File).to receive(:exist?).with('/usr/ports/.portsnap.INDEX')
                                           .and_return(true)
        end

        it 'does not fetch and extract' do
          expect(chef_run).to_not run_execute("#{portsnap_bin} fetch extract #{portsnap_options}")
        end
      end # context when the ports tree is already extracted

      context 'when the ports tree is not extracted' do
        before do
          allow(::File).to receive(:exist?).with('/usr/ports/.portsnap.INDEX')
                                           .and_return(false)
        end

        it 'fetches and extracts with the patched portsnap bin' do
          expect(chef_run).to run_execute("#{portsnap_bin} fetch extract #{portsnap_options}")
            .at_compile_time
        end
      end # context when the ports tree is not extracted
    end # context on FreeBSD 10
  end # context with Compile Time
end
