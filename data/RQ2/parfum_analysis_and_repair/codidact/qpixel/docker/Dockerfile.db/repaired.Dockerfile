FROM mysql

# docker build -t qpixel_db -f docker/Dockerfile.db .

# These commands will be run on init of the container
COPY docker/mysql-init.sql /docker-entrypoint-initdb.d/mysql-init.sql