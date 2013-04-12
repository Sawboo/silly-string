class mysql ($password){

    $packages = ["mysql-server", "libmysqld-dev", "libmysqlclient-dev"]

    package { $packages: ensure => installed}

    file {"/etc/mysql/my.cnf":
        path => "/etc/mysql/my.cnf",
        mode => 0644,
        owner => root,
        group => root,
        ensure => file,
        require => Package["mysql-server"],
        notify => Service["mysql"],
        content => template("mysql/my.cnf"),
    }

    service { "mysql":
        ensure => running,
        enable => true,
        hasrestart => true,
        subscribe => [Package["mysql-server"], File["/etc/mysql/my.cnf"]],
    }

    # First run? Set up the root user.
    exec { "set-mysql-root-password":
        unless => "mysqladmin -uroot -p$password status",
        path => ["/bin", "/usr/bin"],
        command => "mysqladmin -uroot password $password",
        require => Package["mysql-server"],
    }

    # Create an initial database.
    exec { "create-${DB_NAME}-db":
        unless => "mysql -uroot ${DB_NAME}",
        command => "mysql -uroot -e \"create database ${DB_NAME};\"",
        require => Service["mysql"],
    }
    # Grant access to the database.
    exec { "grant-${DB_USER}-db":
        unless => "mysql -u${DB_USER} -p${DB_PASS}",
        command =>  "mysql -uroot -e \"
         CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
         CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
         GRANT ALL PRIVILEGES ON *.* to '${DB_USER}'@'%';
         GRANT ALL PRIVILEGES ON *.* to '${DB_USER}'@'localhost';\"",
        require => [Service["mysql"], Exec["create-${DB_NAME}-db"]]
    }

}