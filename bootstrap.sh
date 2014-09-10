service mysql bootstrap
mysql -e 'GRANT ALL ON *.* TO 'galera'@'localhost' IDENTIFIED BY "galera"'
mysql -e 'GRANT ALL ON *.* TO 'galera'@"%" IDENTIFIED BY "galera"'