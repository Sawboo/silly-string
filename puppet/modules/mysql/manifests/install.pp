class mysql::install {

    # Required mysql packages.
    $packages = ["mysql-server", "mysql-devel", "mysql"]

    package { $packages:
        ensure => installed,
        require => User["mysql"],
    }

    # Create a user for the mysql service.
    user { "mysql":
        ensure => present,
        comment => "MySQL user",
        gid => "mysql",
        shell => "/bin/false",
        require => Group["mysql"],
    }

    # Create a group for the service.
    group { "mysql":
        ensure => present,
    }

    # Update my.cnf with the given template.
    file { "/etc/my.cnf":
        ensure => present,
        content => template("mysql/my.cnf"),
        owner => "mysql",
        group => "mysql",
        require => Package[$packages],
        notify => Class["mysql::service"],
    }
}