# set base image
FROM python:3.8

# set the working directory in the container
WORKDIR /var/tmp/jenkins

# install dependencies
RUN pip install --no-cache-dir requests

# copy the content of the local src directory to the working directory
COPY packages/ .

# command to run on container start
CMD [ "python", "./feature1.py" ]
