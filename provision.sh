echo "
# MariaDB 10.0 CentOS repository list - created 2014-09-09 15:53 UTC
# http://mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.0/centos6-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1" | sudo tee -a /etc/yum.repos.d/mariadb.repo

wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
sudo rpm -Uvh remi-release-6*.rpm epel-release-6*.rpm
sudo sed -i "s/https/http/" /etc/yum.repos.d/epel.repo

sudo rpm -Uhv http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm

sudo yum install -y socat
sudo yum install -y galera
sudo yum install -y MariaDB-Galera-server
sudo yum install -y MairaDB-shared

sudo yum install -y xtrabackup
sudo yum install -y nc
sudo yum install -y rsync

sudo echo 0 > /selinux/enforce

sudo iptables -L
sudo /etc/init.d/iptables stop
sudo chkconfig iptables off

cat > /etc/my.cnf.d/server.cnf <<EOF
#
# These groups are read by MariaDB server.
# Use it for options that only the server (but not clients) should see
#
# See the examples of server my.cnf files in /usr/share/mysql/
#

# this is read by the standalone daemon and embedded servers
[server]

# this is only for the mysqld standalone daemon
[mysqld]
innodb_buffer_pool_size=1G
innodb_log_file_size=128M
innodb_flush_log_at_trx_commit=0
innodb-file-per-table
server-id=99999

binlog_format=ROW
default-storage-engine=InnoDB
innodb_autoinc_lock_mode=2

query_cache_size=0
query_cache_type=OFF

#
# * Galera-related settings
#
[galera]
# Mandatory settings
#wsrep_provider=
#wsrep_cluster_address=
#wsrep_slave_threads=1
#binlog_format=row
#default_storage_engine=InnoDB
#innodb_autoinc_lock_mode=2
#query_cache_size=0
#
# Optional setting
#innodb_flush_log_at_trx_commit=0

# this is only for embedded server
[embedded]

# This group is only read by MariaDB servers, not by MySQL.
# If you use the same .cnf file for MySQL and MariaDB,
# you can put MariaDB-only options here
[mariadb]

# This group is only read by MariaDB-10.0 servers.
# If you use the same .cnf file for MariaDB of different versions,
# use this group for options that older servers don't understand
[mariadb-10.0]
EOF

cat > /etc/my.cnf.d/galera.cnf <<EOF
[mysqld]
wsrep_provider=/usr/lib64/galera/libgalera_smm.so
wsrep_cluster_name="rackspace_trn"
wsrep_provider_options="gcache.size=512M"
wsrep_cluster_address="gcomm://172.16.0.101,172.16.0.102,172.16.103"
wsrep_slave_threads=2
wsrep_sst_method=xtrabackup
wsrep_sst_auth=galera:galera
EOF

cat > /etc/my.cnf <<EOF
#
# This group is read both both by the client and the server
# use it for options that affect everything
#
[mysqld]
datadir=/var/lib/mysql
basedir=/usr


[client-server]

#
# include all files from the config directory
#
!includedir /etc/my.cnf.d

EOF