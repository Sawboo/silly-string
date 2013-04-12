# Get mysql up and running
class mysql {

    # Install required mysql packages.
    package {
        ["mysql-server", "mysql-devel"]:
            ensure => installed;
    }

    # Start the mysqld service.
    service { "mysqld":
        ensure => running,
        enable => true,
        require => Package['mysql-server'];
    }
}