# -*- mode: ruby -*-
# vi: set ft=ruby :

# Creates a 3 node cluster
nodes = {
  'mariadb' => [3, 101],
}

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Virtual Box
  config.vm.box = "chef/centos-6.5"

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
    config.cache.enable :yum
  else
    puts "[-] WARN: This would be much faster if you ran vagrant plugin install vagrant-cachier first"
  end

  # VMware Fusion
  config.vm.provider "vmware_fusion" do |vmware, override|
    override.vm.box = "chef/centos-6.5"

    # Fusion Performance Hacks
    vmware.vmx["logging"] = "FALSE"
    vmware.vmx["MemTrimRate"] = "0"
    vmware.vmx["MemAllowAutoScaleDown"] = "FALSE"
    vmware.vmx["mainMem.backing"] = "swap"
    vmware.vmx["sched.mem.pshare.enable"] = "FALSE"
    vmware.vmx["snapshot.disabled"] = "TRUE"
    vmware.vmx["isolation.tools.unity.disable"] = "TRUE"
    vmware.vmx["unity.allowCompostingInGuest"] = "FALSE"
    vmware.vmx["unity.enableLaunchMenu"] = "FALSE"
    vmware.vmx["unity.showBadges"] = "FALSE"
    vmware.vmx["unity.showBorders"] = "FALSE"
    vmware.vmx["unity.wasCapable"] = "FALSE"
    vmware.vmx["memsize"] = "2048"
    vmware.vmx["numvcpus"] = "1"
    vmware.vmx["vhv.enable"] = "TRUE"
  end

  nodes.each do |prefix, (count, ip_start)|
    count.times do |i|

        hostname = "%s-%02d" % [prefix, (i+1)]
        config.vm.define hostname do |box|
          box.vm.hostname = "#{hostname}"
          box.vm.network :private_network, ip: "172.16.0.#{ip_start+i}", :netmask => "255.255.0.0"
          box.vm.network :private_network, ip: "10.10.0.#{ip_start+i}", :netmask => "255.255.0.0"
          box.vm.provision :shell, :path => "provision.sh"
          if ip_start == 101
            box.vm.provision :shell, :path => "bootstrap.sh"
          else
            box.vm.provision :shell, :inline => "service mysql start"
          end
        end
      end
    end
end