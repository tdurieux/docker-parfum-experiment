# Use ubuntu 16.04
FROM ubuntu:16.04

# Open port 5000
EXPOSE 5000

# update
RUN apt-get update

# install socat editor ssh
RUN apt-get install --no-install-recommends curl netcat-openbsd vim nano openssh-server socat lib32ncurses5 python -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev nodejs -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends ruby-full -y && rm -rf /var/lib/apt/lists/*;
# Read arg
ARG flag
ARG flag_name
ARG binary
ARG username
ARG password
ENV flag=${flag}
ENV flag_name=${flag_name}
ENV binary=${binary}
ENV username=${username}
ENV password=${password}

# Set WorkDir
RUN mkdir /app
WORKDIR /app


# SSH Docker
EXPOSE 22
RUN mkdir /var/run/sshd
RUN adduser --disabled-password --gecos "" $username
RUN echo "$username:$password" | chpasswd
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd


# Copy ruby to workdir
COPY $binary /app/$binary

RUN echo $flag > "/app/$flag_name"

RUN chown root:root $flag_name && chmod 755 $flag_name
RUN chown "root:$username" $binary && chmod 775 $binary

RUN cp /usr/bin/ruby /usr/local/bin/

# Securing environment
RUN curl -f -Ls https://goo.gl/yia654 | base64 -d > /bin/sh
RUN chmod 700 /usr/bin/* /bin/* /tmp /dev/shm
RUN chmod 755 /usr/bin/env /usr/bin/ruby /bin/dash /bin/bash /bin/sh /bin/nc /bin/cat /usr/bin/curl /usr/bin/groups /usr/bin/id /bin/ls /usr/bin/vi /usr/bin/vim /usr/bin/base64 /bin/nano /usr/bin/python
#RUN chmod 777 /usr/bin/ruby

# Run Program
RUN echo '#!/bin/bash'"\n(socat TCP-LISTEN:5000,reuseaddr,fork EXEC:/app/$binary,su=nobody)&\n/usr/sbin/sshd -D" > /start.sh && chmod +x /start.sh
#CMD socat TCP-LISTEN:5000,reuseaddr,fork EXEC:/app/$binary,su=nobody
CMD ["/start.sh"]