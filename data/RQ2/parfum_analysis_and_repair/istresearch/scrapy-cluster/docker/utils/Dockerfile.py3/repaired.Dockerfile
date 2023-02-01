FROM python:3.6
MAINTAINER Madison Bahmer <madison.bahmer@istresearch.com>

# os setup
RUN apt-get update
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# move codebase over and install requirements
COPY utils /usr/src/app
RUN pip install --no-cache-dir .
RUN pip install --no-cache-dir nose

# copy testing script into container
COPY docker/run_docker_tests.sh /usr/src/app/run_docker_tests.sh

# set up environment variables

# run command
CMD ["ping", "localhost"]