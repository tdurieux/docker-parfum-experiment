# This Dockerfile creates the container for testing on Archlinux
# You can run, for example: clazy/tests/docker/test_docker.py -b 1.6 , which will run the tests in all containers
# Or explicitly: docker run -i -t iamsergio/clazy-archlinux sh /root/clazy/tests/docker/build-clazy.sh 1.6 -j12 none /usr