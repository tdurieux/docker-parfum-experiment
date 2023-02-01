FROM mysql/mysql-server:5.7
COPY ./init/lanb_wvs.sql /docker-entrypoint-initdb.d/init.sql