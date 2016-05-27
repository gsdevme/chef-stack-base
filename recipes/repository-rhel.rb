include_recipe 'yum-epel'
include_recipe 'yum-ius'

include_recipe 'cron'
package 'yum-cron'