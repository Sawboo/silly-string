# Install python and compiled modules for a development environment.
class python {

    # Install required python packages.
    package {
        ["python-devel", "python-libs", "python-setuptools", "mod_wsgi"]:
            ensure => installed;
    }

    # Install pip with setuptools.
    exec { "pip-install":
        command => "easy_install -U pip",
        creates => "/usr/local/bin/pip",
        require => Package["python-devel", "python-setuptools"]
    }

    # Finally, install virtualenv with pip.
    exec { "pip-install-compiled":
        command => "pip install virtualenv",
        require => Exec['pip-install']
    }

}