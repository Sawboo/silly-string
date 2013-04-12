import "classes/*.pp"

$PROJ_DIR = $project_path

# You can make these less generic if you like, but these are box-specific
# so it's not required.
$DB_NAME = $project_name
$DB_PASS = $password

Exec {
    path => "/usr/local/bin:/usr/bin:/usr/sbin:/sbin:/bin",
}

class dev {
    file {
        "/home/vagrant":
            ensure => directory,
            mode => 755;
    }
    class {
        init: ;
    }
    class { "mysql":
    require => Class[init];
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