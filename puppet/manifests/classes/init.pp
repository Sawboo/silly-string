# Commands to run before all others in puppet.
class init {
    group { "puppet":
        ensure => "present",
    }

    exec { "yum_update":
        command => "yum update -y",
    }
}