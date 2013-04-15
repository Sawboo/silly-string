import "classes/*.pp"

$PROJ_DIR = $project_path

# You can make these less generic if you like, but these are box-specific
# so it's not required.
$DB_USER = $db_user
$DB_PASS = $db_pass

Exec {
    path => "/usr/local/bin:/usr/bin:/usr/sbin:/sbin:/bin",
}

class dev {
    file {
        "/vagrant/sites":
            ensure => directory,
            mode => 755;
    }

    class {init: }

    class { "mysql":
        require => Class[init];
    }

    # Syntax to provision a new database:
    #
    # mysql::db { 'database_name':
    #     db_user => $db_user,
    #     db_pass => $db_pass,
    #     require => Class[mysql];
    # }

    mysql::db { 'dev_db':
        db_user => $db_user,
        db_pass => $db_pass,
        require => Class[mysql];
    }

    class { "python":
        require => Class[mysql];
    }

    class { "nginx":
        require => Class[python],
        server_name => $server_name,
        project_path => $project_path;
    }
}

include dev