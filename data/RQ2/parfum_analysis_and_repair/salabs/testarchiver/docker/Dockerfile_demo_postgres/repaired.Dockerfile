# Postgres 13 fixture_archive database with sample data.
# Sample data is generated with run_fixture_robot.sh script
#
# Example usage: 
# Building `docker build -t testarchiver_demo -f ./Dockerfile_demo_postgres .`
# Running  `docker run --rm -e POSTGRES_PASSWORD=robot -e POSTGRES_USER=testarchiver -e POSTGRES_DB=fixture_archive -p 5432:5432 -t testarchiver_demo:latest`
#