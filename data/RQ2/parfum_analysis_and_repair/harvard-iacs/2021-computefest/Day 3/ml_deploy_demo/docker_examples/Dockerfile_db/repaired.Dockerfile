# The following line will download a Docker image that already is set up with python 3.7, so that we can run our
# simple web application.
FROM python:3.7-slim-buster

# This exposes the port 8081 so that that Docker container can receive requests through this port.
EXPOSE 8081

# Copy our python script over to the Docker container.
COPY hello_world_db.py .

# Need to download and install the "numpy" package
RUN pip3 install --no-cache-dir numpy

# Run our python script/application in the Docker container.
CMD ["python", "./hello_world_db.py"]