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
