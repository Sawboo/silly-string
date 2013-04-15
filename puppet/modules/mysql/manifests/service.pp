class mysql::service {


    service { "mysqld":
        ensure => running,
        hasstatus => true,
        hasrestart => true,
        enable => true,
        require => Class["mysql::install"],
        subscribe => File["/etc/my.cnf"],
    }

    # First run? Set up the root user.
    exec { "set-mysql-password":
        unless => "mysqladmin -uroot -p$db_pass status",
        path => ["/bin", "/usr/bin"],
        command => "mysqladmin -uroot password $db_pass",
        require => Service["mysqld"],
    }

}