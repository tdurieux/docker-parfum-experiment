# To build:
#   docker build -f Dockerfile-test -t gocv-test .
#
# To run tests:
#   xhost +
#   docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix gocv-test
#   xhost -
#