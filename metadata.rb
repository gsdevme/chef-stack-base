name             'stack-base'
license          'MIT Licence'
description      'Stack base for cookbooks'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.1'

depends 'yum-epel', '~> 0.6.5'
depends 'yum-ius', '~> 0.4.5'
depends 'apt', '~> 2.9.2'
depends 'cron', '~> 1.7.6'
depends 'glances', '~> 1.0.3'
depends 'fail2ban', '~> 2.3.0'
depends 'iptables-ng', '~> 2.2.11'
