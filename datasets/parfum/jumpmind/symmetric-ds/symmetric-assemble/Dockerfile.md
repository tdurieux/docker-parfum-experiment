[![SymmetricDS](https://www.jumpmind.com/images/common/symmetricds.png)](https://www.jumpmind.com/products/symmetricds/overview)
- - -
This repository contains the JumpMind Inc. official Docker image for SymmetricDS. This Docker image is based on the openjdk:alpine image. This installation contains the default web server configuration for SymmetricDS.

Overview
===
SymmetricDS is an open source database replication tool that is highly scalable and configurable.  SymmetricDS supports a wide variety of database platforms such as MySQL, Microsoft SQL Server, PostgreSQL, SQLite, Oracle SQL, and more.  Please visit the SymmetricDS website to learn more about the options and features: https://www.symmetricds.org/

Running a SymmetricDS Container
===
To start SymmetricDS using HTTP run the following command:
`docker run -p 31415:31415 --name sym jumpmind/symmetricds`

***Please note that you must allow the IP of the Docker container to connect to the database in your database settings.  If you are running locally, allowing localhost is not sufficient since the Docker container is on a separate subnet.***

Connecting to a Running Container
===
SymmetricDS may require manual configuration on the file system via command line tools.  To do this, run the following command to open a shell on a running container:
`docker exec -it sym /bin/sh`

This will open the default shell for Alpine Linux so that manual changes can be made on the container's file system.

Volumes
===
Volumes allow data and files to be persisted across multiple containers.  This Docker image is configured to allow volumes for the engines, tmp, conf, and security directories so that configuration can be persisted. 

To mount a volume, add one or more of the following argument to the run command:
`-v sym-engines:/opt/symmetric-ds/engines`
`-v sym-tmp:/opt/symmetric-ds/tmp`
`-v sym-conf:/opt/symmetric-ds/conf`
`-v sym-security:/opt/symmetric-ds/security`

As an example, the following run command can be used to start SymmetricDS using HTTP and create the sym-engines, sym-conf, and sym-security volumes:
`docker run -p 31415:31415 --name sym -v sym-engines:/opt/symmetric-ds/engines -v sym-conf:/opt/symmetric-ds/conf -v sym-security:/opt/symmetric-ds/security jumpmind/symmetricds`

The above command will allow the engines, conf, and security directories to be persisted in the sym-engines, sym-conf, and sym-security volumes respectively.  If this container is stopped or deleted, a new container can be created using the same command and the configuration from the previous container will be retained.

Building a SymmetricDS Image
===
`docker build -t symmetricds .`