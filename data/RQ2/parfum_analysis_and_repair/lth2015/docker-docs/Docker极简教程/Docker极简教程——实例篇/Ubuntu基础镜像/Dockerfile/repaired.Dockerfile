FROM ubuntu:latest
ADD jdk1.7.0_79 /usr/local/jdk1.7.0_79
ADD profile /etc/
ADD locale /etc/default/
ENV JAVA_HOME /usr/local/jdk1.7.0_79
ENV PATH $JAVA_HOME/bin:$PATH
ENV LANG en_US.UTF-8
RUN sed -i '/archive.ubuntu.com/s/archive.ubuntu.com/cn.archive.ubuntu.com/g' /etc/apt/sources.list
RUN apt-get update
RUN apt-get install --no-install-recommends telnet -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends gcc -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends make -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends dnsutils -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends gdb -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends traceroute -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends vim -y && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /apps/product
ENV CATALINA_HOME /apps/product/tomcat7
ENV CATALINA_SH /apps/product/tomcat7/bin/catalina.sh
RUN useradd app
EXPOSE 8080

# ADD tomcat7 /apps/product/tomcat7
# RUN chown -Rf app:app /apps/product/tomcat7
# USER app

# ENTRYPOINT [ "/apps/product/tomcat7/bin/catalina.sh", "run" ]
