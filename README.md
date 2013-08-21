About Silly-String
============

silly-string is a set of Vagrant and Puppet files used to quickly provision a Django development environment on CentOS 6.4

Requirements
----

* Virtualbox
* Vagrant

Getting Started
----

First start by cloning the silly-string repo to a new directory for your development virtual machine.

    mkdir testbox
    git clone https://github.com/Sawboo/silly-string.git ./testbox

Almost all of the configuration can be done from ``vagrantconfig_local.yaml``

By default, a development database will be created named 'development' that can be accessed with the credentials in ``vagrantconfig_local.yaml``

If you wish to change the name of the default database or prevision more databases, take a look at line 27 of ``/puppet/manifests/vagrant.pp``

Creating the VM
----

To create the virtual machine, simply run: ``vagrant up``


Other Notes
----

By default, silly-string runs ``yum update -y`` to update all of the system packages when being provisioned. As the base-box gets older, this process will take longer and longer, possibly causing a timeout error. You can increase the amount of time vagrant will wait in ``Vagrantfile`` or you can comment the update lines out.

Create virtual enviroments and start projects in: ``/vagrant/sites`` so they can be accessed from the host machine.

To access a Django development server from the host machine, run the command (in the vm):

    python manange.py runserver 0.0.0.0:8000

Then load the url ``localhost:8888`` from your host browser.

To connect to the development database with Django, in: ``settings.py``

    ...
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.mysql',
            'HOST': '127.0.0.1',
            'PORT': '3306',
    ....
