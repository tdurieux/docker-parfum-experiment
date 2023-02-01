# How to use Dockerfile

Dockerfile in this repository creates Relation Analyzer instance running on port
8080.

This image is based on Tomcat image and does not contain any database. For full
functionality (caching, search) database is required. This image supports
PostgreSQL databases. To setup the database provide following environment
variables:
* `DB_URL` - database URL in format `jdbc:postgresql://[host]/[database name]`
* `DB_USER` - database username
* `DB_PASSWORD` - database password
* `SRTM_DIRECTORY` - directory where SRTM files are available


You can build the image using command:
```
docker build -t relation-analyzer .
```

# Using docker-compose