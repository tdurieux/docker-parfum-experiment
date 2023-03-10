FROM ruby:2.1.6

# install redis
RUN cd /usr/src \
    && wget -c https://download.redis.io/redis-stable.tar.gz \
    && tar xvzf redis-stable.tar.gz \
    && cd redis-stable \
    && make && make install \
    && echo -ne '\n' | utils/install_server.sh && rm redis-stable.tar.gz

# install unix odbc (for snowflake)
RUN apt-get update && apt-get install --no-install-recommends -y unixodbc-dev && rm -rf /var/lib/apt/lists/*;

# snowflake
RUN curl -f -o /tmp/snowflake_linux_x8664_odbc-2.19.8.tgz https://sfc-repo.snowflakecomputing.com/odbc/linux/latest/snowflake_linux_x8664_odbc-2.19.8.tgz && cd /tmp && gunzip snowflake_linux_x8664_odbc-2.19.8.tgz && tar -xvf snowflake_linux_x8664_odbc-2.19.8.tar && cp -r snowflake_odbc /usr/bin && rm -r /tmp/snowflake_odbc && rm snowflake_linux_x8664_odbc-2.19.8.tar

# log location
RUN mkdir -p /var/log/aleph
ENV SERVER_LOG_ROOT /var/log/aleph

# make temp writeable
RUN chmod 777 /tmp

RUN gem install aleph_analytics
EXPOSE 3000
