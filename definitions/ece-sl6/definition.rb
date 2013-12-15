Veewee::Session.declare({
  :cpu_count => '1',
  :memory_size=> '512',
  :disk_size => '10140',
  :disk_format => 'VDI',
  :hostiocache => 'on',
  :vm_options => {
    :ioapic => 'on',
    :pae => 'on',
  },
  :os_type_id => 'RedHat_64',
  :iso_file => "SL-64-x86_64-2013-03-18-boot.iso",
  :iso_src => "http://mirror.anl.gov/pub/scientific-linux/6/x86_64/iso/SL-64-x86_64-2013-03-18-boot.iso",
  :iso_md5 => "e9625e2c3b4b02d94ffa478773d5d58f",
  :iso_download_timeout => 1000,
  :boot_wait => "15",
  :boot_cmd_sequence => [ '<Tab> linux ks=http://%IP%:%PORT%/ece-sl6.ks<Enter>' ],
  :kickstart_port => "7124",
  :kickstart_timeout => 10000,
  :kickstart_file => "ece-sl6.ks",
  :ssh_login_timeout => "10000",
  :ssh_user => "root",
  :ssh_password => "root",
  :ssh_key => "",
  :ssh_host_port => "7224",
  :ssh_guest_port => "22",
  :sudo_cmd => "echo '%p'| bash '%f'",
  :shutdown_cmd => "/sbin/halt -h -p",
  :postinstall_files => [
    "base.sh",
    "epel.sh",
    "vagrant.sh",
    "virtualbox.sh",
    "cleanup.sh"
  ],
  :postinstall_timeout => 10000
})
