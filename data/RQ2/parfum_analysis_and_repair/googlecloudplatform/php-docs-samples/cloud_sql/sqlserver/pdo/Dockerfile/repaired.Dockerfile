FROM gcr.io/google_appengine/php72

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

COPY . .

RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl -f https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update && \
    ACCEPT_EULA=Y apt-get --no-install-recommends -y install \
        autoconf \
        build-essential \
        msodbcsql17 \
        unixodbc-dev \
        unzip && rm -rf /var/lib/apt/lists/*;

RUN pecl install pdo_sqlsrv
RUN echo "extension=pdo_sqlsrv.so" > /opt/php72/lib/ext.enabled/ext-pdo_sqlsrv.ini
# RUN phpenmod pdo_sqlsrv
RUN composer update
