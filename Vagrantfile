require "yaml"

# Load up our vagrant config files -- vagrantconfig.yaml first
_config = YAML.load(File.open(File.join(File.dirname(__FILE__),
                    "vagrantconfig.yaml"), File::RDONLY).read)

# Local-specific/not-git-managed config -- vagrantconfig_local.yaml
begin
    _config.merge!(YAML.load(File.open(File.join(File.dirname(__FILE__),
                   "vagrantconfig_local.yaml"), File::RDONLY).read))
rescue Errno::ENOENT # No vagrantconfig_local.yaml found -- that's OK; just
                     # use the defaults.
end

CONF = _config
MOUNT_POINT = '/vagrant'

Vagrant::Config.run do |config|
    config.vm.box = "centos64"
    # config.vm.box_url = "http://dl.dropboxusercontent.com/s/d2yb1bc84lbebdz/centos64.box?dl=1"

    # config.vm.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]

    if CONF['gui'] == true
        config.vm.boot_mode = :gui
    end

    # The inital package update can take a long time,
    # increase vagrant's patience for long CentOS builds.
    config.ssh.max_tries = 50
    config.ssh.timeout   = 1200

    # Setup a shared folder with the host.
    if CONF['nfs'] == false or RUBY_PLATFORM =~ /mswin(32|64)/
        config.vm.share_folder("vagrant-root", MOUNT_POINT, ".")
    else
        config.vm.share_folder("vagrant-root", MOUNT_POINT, ".", :nfs => true)
    end

    # Foward port 8000 to the host machine on port 8888.
    config.vm.forward_port 8000, 8888

    # Provision the server with Puppet.
    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.module_path = "puppet/modules"
        puppet.manifest_file  = "vagrant.pp"

        if CONF['debug'] == true
            puppet.options = "--verbose --debug"
        end

        # Pass options from vagrantconfig_local.yaml
        puppet.facter = [
            ['db_user', CONF['db_user']],
            ['db_pass', CONF['db_pass']],
            ['project_path', MOUNT_POINT],
            ['server_name', CONF['server_name']],
        ]
    end

end
