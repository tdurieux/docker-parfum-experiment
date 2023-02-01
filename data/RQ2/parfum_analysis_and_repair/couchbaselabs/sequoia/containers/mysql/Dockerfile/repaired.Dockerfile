FROM ubuntu_python
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list

RUN apt-get -y --no-install-recommends install mysql-server && rm -rf /var/lib/apt/lists/*;

EXPOSE 3306

CMD ["/usr/bin/mysqld_safe"]
