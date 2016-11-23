Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/trusty64'
  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.provision :ansible_local do |ansible|
    ansible.playbook = 'provision.yml'
  end

  config.vm.define 'server' do |serv|
    serv.vm.hostname = 'jsonapi'
    serv.vm.network 'private_network', ip: '192.168.33.133'
    serv.vm.network 'forwarded_port', guest: 4567, host: 4567
    serv.vm.synced_folder 'server', '/vagrant'
  end

  config.vm.define 'client' do |clnt|
    clnt.vm.synced_folder 'client', '/vagrant'
  end
end
