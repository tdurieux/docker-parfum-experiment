FROM wordpress:latest

RUN sed -i 's#http://.*.debian.org#http://ftp.cn.debian.org#g' /etc/apt/sources.list && \  
    apt-get update && apt-get install --no-install-recommends -y zip && \
    cp /usr/src/wordpress/wp-config-sample.php /usr/src/wordpress/wp-config.php && rm -rf /var/lib/apt/lists/*;
RUN curl -f -o sqlite-plugin.zip https://downloads.wordpress.org/plugin/sqlite-integration.1.8.1.zip && \
    unzip sqlite-plugin.zip -d /usr/src/wordpress/wp-content/plugins/ && \
    cp /usr/src/wordpress/wp-content/plugins/sqlite-integration/db.php /usr/src/wordpress/wp-content && \
    rm -rf sqlite-plugin.zip