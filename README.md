# chef-stack-base
Cookbook to configure a base linux box

Requirements
============

* Chef 12 or greater

Platforms
---------

* Debian/Ubuntu
* RHEL/CentOS

Cookbooks
---------

*  'yum-epel'
*  'yum-ius'
*  'apt'
*  'cron'
*  'glances'
*  'fail2ban'

Usage
=====

include `recipe[stack-base]`