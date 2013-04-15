# Pull everything together.
class mysql {
    include mysql::install, mysql::service
}
