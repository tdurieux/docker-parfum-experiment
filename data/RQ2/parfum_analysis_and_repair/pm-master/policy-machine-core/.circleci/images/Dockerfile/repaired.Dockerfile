# Derived from official mysql image (our base image)
FROM mysql
# Add a database
ENV MYSQL_DATABASE policydb_core
ENV MYSQL_ROOT_PASSWORD pmAdmin
# Add the content of the sql-scripts/ directory to the image
# All scripts in docker-entrypoint-initdb.d/ are automatically
# executed during container startup