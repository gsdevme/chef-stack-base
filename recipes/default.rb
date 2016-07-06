include_recipe 'stack-base::repository'

package 'git'
package 'vim'
package 'dnsmasq'
package 'screen'
package 'telnet'
package 'ntp'
package 'strace'
package 'ncdu'
package 'mlocate'
package 'logrotate'

services = []

case node[:platform_family]
when 'debian'
  package 'netcat'
  include_recipe 'glances'

  services = [
    'cron',
    'ntp',
    'dnsmasq',
    'ssh'
  ]
when 'rhel'
  package 'nc'
  package 'glances'
  package 'bind-utils'
  package 'sysstat'

  services = [
    'crond',
    'ntpd',
    'dnsmasq',
    'sshd',
    'yum-cron'
  ]

  if node['platform_version'].to_i == 7
    %w(firewalld tuned).each do |service|
      service "#{service}" do
        ignore_failure true
        supports :start => true, :stop => true, :restart => true, :reload => true, :status => true
        action [:disable, :stop]
      end
    end
  end
end

# 3 days banned
node.default[:fail2ban][:bantime] = 10800

include_recipe 'fail2ban'

node.default['iptables-ng']['rules']['filter']['INPUT']['zzz-default'] = 'DROP [0:0]'
node.default['iptables-ng']['rules']['filter']['INPUT']['ssh']['rule'] = '--protocol tcp --dport 22 --match state --state NEW --jump ACCEPT'

include_recipe 'iptables-ng'

services.each do |service|
  service "#{service}" do
    supports :start => true, :stop => true, :restart => true, :reload => true, :status => true
    action [:enable, :start]
  end
end
