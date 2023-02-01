# Postgres 13 with empty fixture_archive database.
#
# Example usage: 
# Building `docker build -t testarchiver_db  -f ./Dockerfile_db_postgres ..` Notice: the build context is set to parent directory
# Running  `docker run --rm -e POSTGRES_PASSWORD=robot -e POSTGRES_USER=testarchiver -e POSTGRES_DB=fixture_archive -p 5432:5432 -t testarchiver_db:latest`
#