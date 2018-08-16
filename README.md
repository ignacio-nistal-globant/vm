# Ubuntu Virtual Machine #

This is a very flexible virtual machine that allows you to create a simple Ubuntu Server Bionic64 for LAMP stack developers which also includes many related modern development tools.

Please read all the document before start using the project.

### Overview ###

A lot of PHP websites and applications don’t require much server configuration or overhead at first. This virtual machine should have all your needs for doing basic development so you don’t have to worry about configuring the virtual environment and you can simply focus on your code.

### Setup ###

The project has the following pre-requisites:

* Git [http://git-scm.com/](http://git-scm.com/)
* Vagrant [http://www.vagrantup.com/](http://www.vagrantup.com/)
* VirtualBox [http://www.virtualbox.org/](http://www.virtualbox.org/)

Once you have installed the prerequisites, fork and clone the project repository and modify the following lines in [vagrantfile](./vagrantfile):
```
VBOX_CORE = "1"
VBOX_MEMORY = "1024"
VBOX_NAME = "Development"
```

Now execute the following command:
```
$ vagrant up
```

Once ready, you can test it by opening following URL on your browser:
```
http://127.0.0.1:8080/
https://127.0.0.1:8443/ (secure)
```

If you want to manage the Web Server or the MySQL database:
```
https://127.0.0.1:8989/ (secure only, webmin has its own server)

User: vagrant
Password: vagrant
```
```
http://127.0.0.1:8080/phpmyadmin/
https://127.0.0.1:8443/phpmyadmin/ (secure)
```

That's all, as you can see, very simple.

If you need more information related to Vagrant, go to the official [Vagrant documentation](https://www.vagrantup.com/docs/).

### Available Tools ###

The project has an optional tool that can be used during the vagrant up or reload.

Using build as custom argument, the tool will execute [build.sh](./build.sh) as soon as finish with the start or reload process. You can add any line you need into this file.

To start the build process, execute the following command:
```
$ vagrant --custom=build up
```

The project also has a group of NPM tools that allow the developer to manage the the project build and assets packaging with minimal effort.

The **build:css** tool deletes the contents of the theme directory, executes node-sass and autoprefixer.
```
$ npm run build:css

```

The **build:fonts** tool deletes the contents of the theme directory, and copy all available files in the source directory.
```
$ npm run build:fonts
```

The **build:images** tool deletes the contents of the theme directory, executes imagemin.
```
$ npm run build:images
```

The **build:js** tool deletes the contents of the theme directory, executes eslint and uglifyjs.
```
$ npm run build:js
```

The **build:all** tool executes ALL the tasks explained above in a single command.
```
$ npm run build:all
```

And the **watch:all** tools executes onchange and remain waiting for any css or js change.
```
$ npm run watch:all
```

### Tips ###

**How to deal with RSA server sertificates? (this one fixes many cetifiates related issues)**

1. Go to the certificates directory:
```
$ cd /var/www/provision/vm/ssl
```
2. Generate private key and certificate signing request:
```
$ openssl genrsa -des3 -passout pass:x -out localhost.pass.key 2048
$ openssl rsa -passin pass:x -in localhost.pass.key -out localhost.key
$ rm localhost.pass.key
$ openssl req -new -key localhost.key -out localhost.csr
```
3. Generate SSL certificate
```
$ openssl x509 -req -days 365 -in localhost.csr -signkey localhost.key -out localhost.crt
```
4. Restart the Apache Web Server or, even better, the vagrant VM.

### Why Vagrant and not Docker ###

Vagrant is a tool focused on providing a consistent development environment workflow across multiple operation systems. Docker is a container management that can consistently run software as long as a containerization system exists.

Containers are generally more lightweight than virtual machines, so starting and stopping containers is extremely fast. Most common development machines don't have a containerization system built-in, and Docker uses a virtual machine with Linux installed to provide that.

Currently, Docker lacks support for certain operating systems (such as BSD). If your target deployment is one of these operating systems, Docker will not provide the same production parity as a tool like Vagrant. Vagrant will allow you to run a Windows development environment on Mac or Linux, as well.

For microservice heavy environments, Docker can be attractive because you can easily start a single Docker VM and start many containers above that very quickly. This is a good use case for Docker. Vagrant can do this as well with the Docker provider. A primary benefit for Vagrant is a consistent workflow but there are many cases where a pure-Docker workflow does make sense.

Both Vagrant and Docker have a vast library of community-contributed "images" or "boxes" to choose from.

### MIT License ###

##### Copyright (c) 2015-2018 Esteban Spina #####

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
