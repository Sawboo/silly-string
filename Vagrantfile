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
PROJECT_NAME = 'testbox-project'

Vagrant::Config.run do |config|
    config.vm.box = "centos64"
    # config.vm.box_url = "D:/Chadwick/centos64.box"

    # config.vm.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]

    if CONF['gui'] == true
        config.vm.boot_mode = :gui
    end

    # Increase vagrant's patience during hang-y CentOS bootup
    # see: https://github.com/jedi4ever/veewee/issues/14
    config.ssh.max_tries = 50
    config.ssh.timeout   = 300

    # nfs needs to be explicitly enabled to run.
    if CONF['nfs'] == false or RUBY_PLATFORM =~ /mswin(32|64)/
        config.vm.share_folder("vagrant-root", MOUNT_POINT, ".")
    else
        config.vm.share_folder("vagrant-root", MOUNT_POINT, ".", :nfs => true)
    end

    config.vm.forward_port 8000, 8888

    # config.vm.share_folder "v-data", "/vagrant_data", "./"

    # config.vm.provision :shell, :path => "bootstrap.sh"

    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.module_path = "puppet/modules"
        puppet.manifest_file  = "vagrant.pp"

        if CONF['debug'] == true
            puppet.options = "--verbose --debug"
        end

        puppet.facter = [
            ['username', CONF['username']],
            ['password', CONF['password']],
            ['project_path', MOUNT_POINT],
            ['project_name', PROJECT_NAME],
            ['server_name', CONF['server_name']],
        ]
    end

end
