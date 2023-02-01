# Usage:
# Assuming you want to share the "files" subdirectory
# and your ngPost config is ngPost.docker.conf.
# $ docker build -t ngpost .
# $ docker run -it -v $PWD/files:/root/files -v $PWD/ngPost.docker.conf:/root/.ngPost ngpost ARGUMENTS