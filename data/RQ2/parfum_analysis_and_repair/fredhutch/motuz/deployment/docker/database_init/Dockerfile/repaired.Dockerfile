# Build as
# docker build --no-cache=true -t fredhutch/motuz_database_init:latest -f deployment/docker/database_init/Dockerfile .
# docker run -it --rm -v /docker/volumes/postgres:/var/lib/postgresql/data fredhutch/motuz_database_init:latest