# Run tests in a more reproducible and isolated environment.
#
# Build the docker image once with:
#   docker build -t eccodes .
# Run the container with:
#   docker run --rm -it -v `pwd`:/src eccodes-python
#