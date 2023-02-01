FROM swiftdocker/swift:latest

RUN apt-get -y update && apt-get -y --no-install-recommends install libpq-dev make git postgresql-client && rm -rf /var/lib/apt/lists/*;
COPY . /var/www/PostgreSQL-Swift
WORKDIR /var/www/PostgreSQL-Swift
RUN touch Makefile
