FROM mysql:latest

ENV MYSQL_ROOT_PASSWORD 123  
ENV MYSQL_DATABASE CHIRINOS  
ENV MYSQL_USER users_service  
ENV MYSQL_PASSWORD 123

ADD setup.sql /docker-entrypoint-initdb.d
