vagrant-puppet-boxes
====================

Vagrant configuration and bootstrap that uses my [masterless puppet-boxes setup](https://github.com/mamchenkov/puppet-boxes).

You can specify which manifests to execute via the provision arguments in the Vagrantfile.  If no manifests are given, then base is assumed.

You can also use this bootstrap for bringing up non-Vagrant boxes.  For example the following works just fine for Amazon AWS as the provision command:

```
# wget -O - https://raw.githubusercontent.com/mamchenkov/vagrant-puppet-boxes/master/bootstrap.sh | /bin/bash
```
