# Commands to run before all others in puppet.
class init {
    group { "puppet":
        ensure => "present",
    }

    # Update the system packages.
    exec { "yum_update":
        command => "yum update -y",
    }

    # Disable the firewall on restart.
    exec { "disable_iptables":
        command => "sudo chkconfig iptables off",
        before => Service["iptables"],
    }

    # Stop the firewall.
    service { "iptables":
        ensure => stopped,
    }
}