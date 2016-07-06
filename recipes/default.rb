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
    begin
      %w(firewalld tuned).each do |service|
        service "#{service}" do
          ignore_failure true
          supports :start => true, :stop => true, :restart => true, :reload => true, :status => true
          action [:disable, :stop]
        end
      end
    rescue Chef::Exceptions::ResourceNotFound
      #service doesn't exist
    end
  end
end

# 3 days banned
node.default[:fail2ban][:bantime] = 10800

include_recipe 'fail2ban'

include_recipe 'iptables-ng'

iptables_ng_chain 'STANDARD-FIREWALL'

iptables_ng_rule 'STANDARD-FIREWALL' do
  chain 'INPUT'
  rule '--jump STANDARD-FIREWALL'
end

iptables_ng_rule "20-ssh" do
  chain 'STANDARD-FIREWALL'
  rule "--protocol tcp --dport ssh --jump ACCEPT"
end

iptables_ng_rule "zzzz-reject_other-ipv4" do
  chain 'STANDARD-FIREWALL'
  rule "--jump REJECT --reject-with icmp-port-unreachable"
  ip_version 4
end

iptables_ng_rule "zzzz-reject_other-ipv6" do
  chain 'STANDARD-FIREWALL'
  rule "--jump REJECT --reject-with icmp6-port-unreachable"
  ip_version 6
end

services.each do |service|
  service "#{service}" do
    supports :start => true, :stop => true, :restart => true, :reload => true, :status => true
    action [:enable, :start]
  end
end
