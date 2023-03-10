FROM mariadb:10.6.4

# ----------------------------------------------------------------
# Add Packages to Image
# ----------------------------------------------------------------
RUN apt-get update && apt-get -y --no-install-recommends install \
    nano && rm -rf /var/lib/apt/lists/*;

# ----------------------------------------------------------------
# Ports to Expose on Container
# ----------------------------------------------------------------
EXPOSE 3306

CMD ["mysqld"]