# USAGE
#
#   1. Build the docker container:
# $ docker build -t crass-app .
#   2.a. Run the test
# $ docker run -it --rm crass-app
#   2.b. Run the container with a bash
# $ docker run -it --rm -v "$PWD":/usr/src/app crass-app bash