# This definition takes username and password parameters and
# creates a new database with access privileges for the defined user.


define mysql::db($db_user, $db_pass) {

        include mysql
        # Create a database with the given parameters.
        exec { "create-${name}-db":
            unless => "/usr/bin/mysql -uroot ${name}",
            command => "/usr/bin/mysql -uroot -p${db_pass} -e \"create database ${name};\"",
            require => Service["mysqld"],
        }
        # Grant access to the database.
        exec { "grant-${name}-access":
            unless => "/usr/bin/mysql -u${db_user} -p${db_pass} ${name}",
            command => "/usr/bin/mysql -uroot -p${db_pass} -e \"grant all on ${name}.* to ${db_user}@localhost identified by '$db_pass';\"",
            require => [Service["mysqld"], Exec["create-${name}-db"]]
        }
}
