# We are creating a custom Dockerfile for MySQL as there is no easy way to
# move a file from host into the container. In our case, it's schema.sql
# There is a proposed improvement to "docker cp" but it's still being 
# discussed (https://github.com/docker/docker/issues/5846).