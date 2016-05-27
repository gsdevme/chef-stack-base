case node[:platform_family]
when 'debian'
  include_recipe 'stack-base::repository-debian'
when 'rhel'
  include_recipe 'stack-base::repository-rhel'
end

