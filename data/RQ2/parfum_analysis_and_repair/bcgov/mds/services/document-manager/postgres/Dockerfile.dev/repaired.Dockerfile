FROM postgres:9.6

# Copy only migration scripts for creation
RUN echo "CREATE USER postgres" >> /docker-entrypoint-initdb.d/01-create-user.sql

# Set the working directory to container entrypoint
WORKDIR /docker-entrypoint-initdb.d