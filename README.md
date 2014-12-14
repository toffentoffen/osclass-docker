osclass-docker
==============

This is a containerized version of [Osclass][osclass]
This container has all the needed configuration to run smoothly this awesome open source classifieds site for free.
![Preview of Osclass][osclass-docker-image]
This containarized version of Osclass is based in the [tutum-docker-lamp container][tutum/lamp] 

Usage
-----

To create the image `morfeo8marc/osclass-docker`, execute the following command on the osclass-docker folder that you have created by cloning the project with `git clone https://github.com/morfeo8marc/osclass-docker.git`:

``` bash
docker build -t morfeo8marc/osclass-docker .
```

Running your LAMP docker image
------------------------------

Start your image binding the external ports 80 and 3306 in all interfaces to your container:

``` bash
docker run -d -p 80:80 -p 3306:3306 morfeo8marc/osclass-docker --name osclass-docker
```

The `--name` argument is used to give the container a human remembeable name beside the UUI that dockers generated for every container.

Test your deployment open your browser an go to [http://localhost/](http://localhost/). If you see the following site everything is installed correctly so far. Only the [installation](#Osclass-installation-steps) for your personal osclass site is needed.

![Main page pre configuration][step1-image]

Connecting to the bundled MySQL server from outside the container
-----------------------------------------------------------------

The first time that you run your container, two new users `admin`  with all privileges and  `osclass` with all the privilege to access the osclassdb database,will be created in MySQL with a random password. To get the password, check the logs of the container by running:
``` bash
docker logs osclass-docker
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

Osclass installation steps
--------------------------------------------------------------
To fully install the osclass classified site, you must go trough the osclass's installation process. It's is very easy, you wil just need:
- Database name.
- Database user name.
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
Password: JMf5FsRYEKQY
========================================================================
```
Once you have all the needed data for the installation do:
1. Go to osclass home page
Go to [http://localhost](http://localhost) or if you have a domain for the host where you have build o pulled your docker image http://yourdomain.com.
You must see the following message and click on the `install` button. Don't worry about the error message, it is just pointg out that this is a fresh installation that need to be configured:

![Main page pre configuration][step1-image]


2. Once you hace clicked in the install button, oscclass will perform a requiremt check. It must pass 100% because we have take care fro you to configure all the stuff that Osclass needs.
![Osclass requirements check][step2-image]
If all passes click on the `Run the install` button.
3. Now it's time to configure the database. At this point is where you will the information. retrieved from the log.

![Osclass database configuration][step3-image]


4. Only on step is left, the Osclass user and contact info information. Fill up the admin username and password as well as the contact information with a web title and a valid contact e-amil. And finally choce your base locations for your classifieds.

![Osclass admin user and contact information][step4-image]


5. That's it. You have a fresh awesome Osclass installation. 

![Osclass admin user and contact information][step4-image]

Now you go to the backend clicking te `Finish and go to the administration panel`.

![Osclass admin panel login][step5-image]

When entering you admin credentials you will see:

![Osclass admin panel][step6-image]

Or visiting your homepage, where now no error message will be printed and you will just see your Osclass homepage.

![Osclass homepage][osclass-docker-image]

Disabling .htaccess
--------------------

`.htacess` is enabled by default. To disable `.htacess`, you can remove the following contents from `Dockerfile`

	# config to enable .htaccess
    ADD apache_default /etc/apache2/sites-available/000-default.conf
    RUN a2enmod rewrite

[osclass]: http://osclass.org/
[preview]: http://osclass.org/wp-content/uploads/2011/01/single_job_board-1024x729.png
[tutum/lamp]: https://registry.hub.docker.com/u/tutum/lamp/
[step1-image]: https://github.com/morfeo8marc/osclass-docker/blob/master/osclass-installation-steps/osclass-step1.png
[step2-image]: https://github.com/morfeo8marc/osclass-docker/blob/master/osclass-installation-steps/osclass-step2.png
[step3-image]: https://github.com/morfeo8marc/osclass-docker/blob/master/osclass-installation-steps/osclass-step3.png
[step4-image]: https://github.com/morfeo8marc/osclass-docker/blob/master/osclass-installation-steps/osclass-step4.png
[step5-image]: https://github.com/morfeo8marc/osclass-docker/blob/master/osclass-installation-steps/osclass-step5.png
[step6-image]: https://github.com/morfeo8marc/osclass-docker/blob/master/osclass-installation-steps/osclass-step6.png
[osclass-docker-image]: https://github.com/morfeo8marc/osclass-docker/blob/master/osclass-installation-steps/osclass-docker.png