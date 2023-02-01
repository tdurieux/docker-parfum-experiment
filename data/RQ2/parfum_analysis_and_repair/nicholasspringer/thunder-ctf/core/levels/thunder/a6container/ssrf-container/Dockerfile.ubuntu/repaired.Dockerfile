# Use Ubuntu 18.04 as the base image
FROM ubuntu:18.04

# Specify your e-mail address as the maintainer of the container image
MAINTAINER Nicholas Springer "nicholas.m.springer@gmail.com"

# Execute apt-get update and install to get Python's package manager
#  installed (pip)
RUN apt-get update -y && apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;

# Copy the contents of the current directory into the container directory /app
COPY . /app

# Set the working directory of the container to /app
WORKDIR /app

# Install the Python packages specified by requirements.txt into the container
RUN pip install --no-cache-dir -r requirements.txt

# Set the program that is invoked upon container instantiation
ENTRYPOINT ["python"]

# Set the parameters to the program
CMD ["app.py"]
