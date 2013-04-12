# Install python and compiled modules for project
class python {

    package {
        ["python-devel", "python-libs", "python-setuptools", "mod_wsgi"]:
            ensure => installed;
    }

    exec { "pip-install":
        command => "easy_install -U pip",
        creates => "/usr/local/bin/pip",
        require => Package["python-devel", "python-setuptools"]
    }

    exec { "pip-install-compiled":
        command => "pip install virtualenv",
        require => Exec['pip-install']
    }

}