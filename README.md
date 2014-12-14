osclass-docker
==============

This is a containerized version of [Osclass][osclass]
This container has all the needed configuration to run smoothly this awesome open source classifieds site for free.

This containarized version of Osclass is based in the [tutum-docker-lamp container][tutum/lamp] 
 
![Preview of Osclass][preview]

Usage
-----

To create the image `morfeo8marc/osclass-docker`, execute the following command on the tutum-docker-lamp folder:

``` bash
docker build -t morfeo8marc/osclass-docker .
```

You can now push your new image to the registry:

``` bash
	docker push morfeo8marc/osclass-docker
```

Running your LAMP docker image
------------------------------

Start your image binding the external ports 80 and 3306 in all interfaces to your container:

``` bash
	docker run -d -p 80:80 -p 3306:3306 morfeo8marc/osclass-docker
```
Test your deployment open your browser an go to http://localhost/

![Main page pre configuration][../osclass-installation-steps/osclass-step1.png]

Connecting to the bundled MySQL server from outside the container
-----------------------------------------------------------------

The first time that you run your container, two new users `admin`  with all privileges and  `osclass` with all the privilege to access the osclassdb database,will be created in MySQL with a random password. To get the password, check the logs of the container by running:
``` bash
	docker logs $CONTAINER_ID
```
You will see an output like the following:
``` bash
	========================================================================
	You can now connect to this MySQL Server using:

	    mysql -uadmin -p47nnf4FweaKu -h<host> -P<port>

	Please remember to change the above password as soon as possible!
	MySQL user 'root' has no password but only allows local connections
	========================================================================

	========================================================================
	You can now connect to this MySQL Server using:

	    mysql -uosclass -pJMf5FsRYEKQY -h<host> -P<port>

	Please remember to change the above password as soon as possible!
	MySQL user 'root' has no password but only allows local connections
	========================================================================
```

In this case, `47nnf4FweaKu` is the password allocated to the `admin` user.

You can then connect to MySQL:
``` bash
	 mysql -uadmin -p47nnf4FweaKu
```
Remember that the `root` user does not allow connections from outside the container - you should use this `admin` user instead!

If you want to connect with the `osclass`user:
``` bash
	 mysql -uosclass -pJMf5FsRYEKQY
```

Setting a specific password for the MySQL server admin account
--------------------------------------------------------------

If you want to use a preset password instead of a random generated one, you can set the environment variable `MYSQL_PASS` to your specific password to the `admin user and `MYSQL_OSCLASS_USER` for the `osclass` user when running the container:
``` bash
	docker run -d -p 80:80 -p 3306:3306 -e MYSQL_PASS="mypass" -e MYSQL_OSCLASS_USER="myosclasspass"  morfeo8marc/osclass-docker
```
You can now test your new admin password:
``` bash
	mysql -uadmin -p"mypass"
```
You can now test your new admin password:
``` bash
	mysql -uosclass -p"myosclasspass"
```

Osclass installation step
--------------------------------------------------------------
To fully install the osclass classified site, you must go trough the osclass's installation process. It's is very easy, you wil just need:
- Database name:
- Database user name:
- Database user name's password.

To get this data you can get it form the container log:
``` bash
	docker logs $CONTAINER_ID
```
You will see an output like the following:
``` bash
========================================================================
This information will be needed in the Osclass installation process.

Go to http://localhost
You will need the following information:

Database name: osclassdb
User name: osclass
Password: foobar
========================================================================
```

Disabling .htaccess
--------------------

`.htacess` is enabled by default. To disable `.htacess`, you can remove the following contents from `Dockerfile`

	# config to enable .htaccess
    ADD apache_default /etc/apache2/sites-available/000-default.conf
    RUN a2enmod rewrite

[osclass]: http://osclass.org/
 [preview]: http://osclass.org/wp-content/uploads/2011/01/single_job_board-1024x729.png
[tutum/lamp]: https://registry.hub.docker.com/u/tutum/lamp/