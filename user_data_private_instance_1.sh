#!/bin/bash
apt -y update
apt install -y apache2
apt install -y php7.2 php-curl
apt install -y mysql-server
apt install -y php7.2-mysql
systemctl start mysql
systemctl start apache2
	         	## create mysql user and adding values to database
mysql -e "create user 'testUser'@localhost identified by 'passw0rd';"
mysql -e "grant all privileges on *.* to 'testUser'@'localhost';"
mysql -e "flush privileges;"
mysql -u testUser -ppassw0rd -e "create database test;"
mysql -u testUser -ppassw0rd -e "use test;"
mysql -u testUser -ppassw0rd -e "use test; create table testtable(id varchar(3), first_name varchar(30), last_name varchar(30));"
mysql -u testUser -ppassw0rd -e 'use test; insert into testtable values("1", "khadeer Ali", "Mohammand");'
mysql -u testUser -ppassw0rd -e 'use test; insert into testtable values("2", "Sourav", "Gumber");'
mkdir /var/www/html/api
touch /var/www/html/api/data.php 
	             ## adding php script to fetch from private subnet
echo "<?php " > /var/www/html/api/data.php
echo "header(\"Access-Control-Allow-Origin: *\"); " >> /var/www/html/api/data.php
echo "\$link = new mysqli(\"localhost\",\"testUser\",\"passw0rd\",\"test\"); " >> /var/www/html/api/data.php
echo "echo \"\n Connected with database 1\"; " >> /var/www/html/api/data.php
echo "if(\$link === false){ " >> /var/www/html/api/data.php
echo "    die(\"ERROR: Could not connect. \" . mysqli_connect_error()); " >> /var/www/html/api/data.php
echo "} " >> /var/www/html/api/data.php
echo "\$sql = \"SELECT * FROM testtable\"; " >> /var/www/html/api/data.php
echo "if(\$result = mysqli_query(\$link,\$sql)){ " >> /var/www/html/api/data.php
echo "    if(mysqli_num_rows(\$result) > 0){ " >> /var/www/html/api/data.php
echo "        echo \"<table><tr><th>ID</th><th>Name</th></tr>\"; " >> /var/www/html/api/data.php
echo "        while(\$row = mysqli_fetch_array(\$result)){ " >> /var/www/html/api/data.php
echo "                 echo \"<tr><td>\".\$row['id'].\"</td><td>\".\$row['first_name'].\" \".\$row['last_name'].\"</td></tr>\"; " >> /var/www/html/api/data.php
echo "        } " >> /var/www/html/api/data.php
echo '        echo "</table>"; ' >> /var/www/html/api/data.php
echo "        mysqli_free_result(\$result); " >> /var/www/html/api/data.php
echo "    } else{ " >> /var/www/html/api/data.php
echo "        echo \"No records matching your query were found.\"; " >> /var/www/html/api/data.php
echo "    } " >> /var/www/html/api/data.php
echo "}else{ " >> /var/www/html/api/data.php
echo "    echo \"ERROR: Could not able to execute \$sql. \" . mysqli_error(\$link); " >> /var/www/html/api/data.php
echo "} " >> /var/www/html/api/data.php
echo "mysqli_close(\$link); " >> /var/www/html/api/data.php
echo "?>" >> /var/www/html/api/data.php
	             # changes made in php.ini file to run curl command
echo "extension=curl" >> /etc/php/7.2/apache2/php.ini
echo "extension=mysqli" >> /etc/php/7.2/apache2/php.ini
echo "display_errors=On" >> /etc/php/7.2/apache2/php.ini
echo "error_reporting=E_ALL" >> /etc/php/7.2/apache2/php.ini
				## Starting services
systemctl restart mysql
systemctl restart apache2