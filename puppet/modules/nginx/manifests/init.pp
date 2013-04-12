# This class gets a basic nginx installation up and running
class nginx($server_name, $project_path) {

    service { "httpd":
        ensure => stopped,
        before => Package['nginx'],
    }

    package { "nginx":
        ensure => installed,
    }

    service { "nginx":
        ensure => running,
        enable => true,
        hasrestart => true,
        require => Package['nginx']
    }

    file { "/etc/nginx/conf.d/virtual.conf":
        path => "/etc/nginx/conf.d/virtual.conf",
        mode => 0644,
        owner => root,
        group => root,
        ensure => file,
        require => Package["nginx"],
        notify => Service["nginx"],
        content => template("nginx/nginx.conf"),
    }

    file { "/etc/nginx/mime.types":
        path => "/etc/nginx/mime.types",
        mode => 0644,
        owner => root,
        group => root,
        ensure => file,
        require => Package["nginx"],
        notify => Service["nginx"],
        content => template("nginx/mime.types"),
      }

    exec {"restart-nginx":
        command => "/etc/init.d/nginx restart",
        refreshonly => true,
        before => Service["nginx"],
    }

}