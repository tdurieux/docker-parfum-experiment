# Use an official Python runtime as a parent image
FROM python:3.7

# Set the working directory to /app
WORKDIR /app

# Copy the requirement.txt file
COPY requirements.txt /app/requirements.txt

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir --trusted-host pypi.python.org -r requirements.txt

# Run some configuration scripts
COPY docker/config/ /config/

RUN cd /config && sh run_all_folder_scripts.sh

WORKDIR /app/soweego/

# Run a BASH shell when the container launches
CMD ["/bin/bash"]
