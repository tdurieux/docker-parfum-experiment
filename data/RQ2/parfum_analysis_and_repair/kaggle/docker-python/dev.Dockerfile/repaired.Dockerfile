# This Dockerfile builds an image to quickly iterate on the kaggle libraries.
#
# Create a new image with the latest kaggle librairies using the latest image
# built by CI with a successful test run as the base.
#
# Usage:
#   cd path/to/docker-python
#   docker build -t kaggle/python-dev -f dev.Dockerfile .
#
#   # you can run a container using the image using:
#   docker run -it --rm kaggle/python-dev /bin/bash
#
#   # you can run the tests against this new image using:
#   ./test -i kaggle/python-dev -p test_user_secrets.py
#