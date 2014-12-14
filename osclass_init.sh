#!/bin/bash

echo "Changing osclass folders permisions"
chmod a+w /app/oc-content/uploads/
chmod a+w /app/oc-content/downloads/
chmod a+w /app/oc-content/languages/
chmod a+w /app/
echo "=> Done!"

echo "Changing osclass folders ownerships"
chown -R www-data:www-data /app
echo "=> Done!"

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

PASS=${MYSQL_OSCLASS_PASS:-$(pwgen -s 12 1)}
_word=$( [ ${MYSQL_OSCLASS_PASS} ] && echo "preset" || echo "random" )
echo "=> Creating MySQL osclassdb database and osclass user with ${_word} password"
mysql -uroot -e "CREATE DATABASE osclassdb DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
mysql -uroot -e "CREATE USER 'osclass'@'%' IDENTIFIED BY '$PASS'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON osclassdb.* TO 'osclass'@'%' WITH GRANT OPTION"


echo "=> Done!"

echo "========================================================================"
echo "You can now connect to this MySQL Server using:"
echo ""
echo "    mysql -uosclass -p$PASS -h<host> -P<port>"
echo ""
echo "Please remember to change the above password as soon as possible!"
echo "MySQL user 'root' has no password but only allows local connections"
echo "========================================================================"

echo "========================================================================"
echo "This information will be needed in the Osclass installation process."
echo ""
echo "Go to http://localhost"
echo "You will need the following information:"
echo ""
echo "Database name: osclassdb"
echo "User name: osclass"
echo "Password: $PASS"
echo "========================================================================"

mysqladmin -uroot shutdown
