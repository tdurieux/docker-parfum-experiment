# like I started with the `docker run -it ubuntu bash` command
FROM ubuntu

# these command get run inside the docker container
# the f command; fs;x
# A end of line (insert); I beginning (insert)
# 0 beginning; $ end
RUN apt-get update && apt-get install --no-install-recommends python -y && rm -rf /var/lib/apt/lists/*;
