FROM mysql:5.5.40

# Change port to have multiple mysql server on single container network
RUN echo "[mysqld]" > /etc/my.cnf
RUN echo "port=3307" >> /etc/my.cnf

EXPOSE 3307