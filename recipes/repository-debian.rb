include_recipe 'apt'
include_recipe 'cron'

node.default[:apt][:unattended_upgrades][:enable] = true

include_recipe 'apt::unattended-upgrades'

