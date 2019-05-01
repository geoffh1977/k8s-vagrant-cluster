# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'
require 'getoptlong'

configFile = 'NONE'

# Configure Custom Command Line Options
opts = GetoptLong.new(
  [ '--config', GetoptLong::REQUIRED_ARGUMENT ]
)
opts.each do |opt, arg|
  case opt
  when '--config'
    configFile = arg
  end
end

if configFile.match('NONE')
  puts ""
  puts " --config Is A Required Option. Please Specify The Config File To Use In config Path (e.g. --config=cluster)."
  puts ""
  exit(1)
end

# Load Selected Hosts File
hosts = YAML.load_file "config/#{configFile}.yml"

# Execute Vagrant Configuration
Vagrant.configure("2") do |config|
  # Configure Virtualbox
  config.ssh.insert_key = false
  config.ssh.forward_agent = true
  check_gest_additions = false
  funcational_vboxsf = false
  config.vm.box = "bento/ubuntu-16.04"

  # Configure Nodes
  hosts.each do |name, data|
    config.vm.define name do |machine|
      machine.vm.hostname = name
      machine.vm.network :private_network, ip: data["ipAddress"]
      machine.vm.provider "virtualbox" do |v|
        v.cpus = data["cpu"]
        v.memory = data["memory"]
        v.name = 'kube-' + name
      end
      machine.vm.provision "ansible_local" do |ansible|
        ansible.playbook = "scripts/setup_node.yml"
      end
    end
  end
end
