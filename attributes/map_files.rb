
default['postfixadmin']['map_files']['path'] = '/etc/postfix/tables'
default['postfixadmin']['map_files']['mode'] = '00640'
default['postfixadmin']['map_files']['owner'] = 'root'
default['postfixadmin']['map_files']['group'] = 'postfix'

default['postfixadmin']['map_files']['list'] = [
  'db_virtual_alias_maps.cf',
  'db_virtual_alias_domain_maps.cf',
  'db_virtual_alias_domain_catchall_maps.cf',
  'db_virtual_domains_maps.cf',
  'db_virtual_mailbox_maps.cf',
  'db_virtual_alias_domain_mailbox_maps.cf',
  'db_virtual_mailbox_limit_maps.cf',
]

