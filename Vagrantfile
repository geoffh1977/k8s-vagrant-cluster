# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'
require 'getoptlong'

config_file = 'NONE'

# Configure Custom Command Line Options
opts = GetoptLong.new(
  ['--config', GetoptLong::REQUIRED_ARGUMENT]
)
opts.each do |opt, arg|
  case opt
  when '--config'
    config_file = arg
  end
end

if config_file == 'NONE'
  # rubocop:disable LineLength
  puts ''
  puts '  --config Is A Required Custom Option. Please Specify The Config File To Use In config Path (e.g. --config=cluster).'
  puts ''
  exit(1)
  # rubocop:enable LineLength
end

# Load Selected Hosts File
hosts = YAML.load_file "config/#{config_file}.yml"

# Execute Vagrant Configuration
Vagrant.configure('2') do |config|
  # Configure Virtualbox
  config.ssh.insert_key = false
  config.ssh.forward_agent = true
  config.vm.box = 'bento/ubuntu-16.04'

  # Configure Nodes
  hosts.each do |name, data|
    config.vm.define name do |machine|
      machine.vm.hostname = name
      machine.vm.network :private_network, ip: data['ipAddress']
      machine.vm.provider 'virtualbox' do |v|
        v.cpus = data['cpu']
        v.memory = data['memory']
        v.name = "k8s-#{config_file}-#{name}"
        v.check_guest_additions = false
        v.functional_vboxsf = false
      end
      machine.vm.provision 'ansible_local' do |ansible|
        ansible.playbook = 'scripts/setup_node.yml'
      end
    end
  end
end
