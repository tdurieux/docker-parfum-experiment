FROM golang

# Install redis server
RUN apt-get update && apt-get install --no-install-recommends -y redis-server && rm -rf /var/lib/apt/lists/*;

# Install and configure mysql
RUN echo 'mysql-server mysql-server/root_password password secret_password' | debconf-set-selections
RUN echo 'mysql-server mysql-server/root_password_again password secret_password' | debconf-set-selections
RUN apt-get install --no-install-recommends -y mysql-server && rm -rf /var/lib/apt/lists/*;
ADD build/my.cnf /etc/mysql/my.cnf
RUN mkdir -p /var/lib/mysql
RUN chmod -R 755 /var/lib/mysql

# Install and get supervisord so that we can run multiple processes.
RUN apt-get install --no-install-recommends -y supervisor && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /var/log/supervisor

# Move local files to the docker image
ADD . /go/src/github.com/GrappigPanda/notorious
ADD config.yaml /etc/
COPY build/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set up Docker volumen management.
RUN mkdir /var/notorious
VOLUME /var/notorious /var/notorious

# Install dependencies
RUN go get gopkg.in/redis.v3
RUN go get github.com/jinzhu/gorm
RUN go get github.com/go-sql-driver/mysql
RUN go get github.com/spf13/viper

# Build notorious
RUN go install github.com/GrappigPanda/notorious

# Set the entry command
CMD ["/usr/bin/supervisord"]

# Allow remote connections into notorious
EXPOSE 3000
