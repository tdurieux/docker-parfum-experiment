FROM ubuntu:14.04

# Update OS
RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -y python-dev python-pip redis-server && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade

# Install Python


# Add requirements.txt
ADD requirements.txt /webapp

# Install uwsgi Python web server
RUN ls -al /webapp
RUN pip install --no-cache-dir uwsgi
# Install app requirements
ADD install.sh /webapp
RUN install.sh
RUN pip install --no-cache-dir -r requirements.txt

# Create app directory
ADD . /webapp

# Set the default directory for our environment
ENV HOME /webapp
WORKDIR /webapp

# Expose port 8000 for uwsgi
EXPOSE 8080

ENTRYPOINT ["python", "manage.py", "runserver", "--host", "0.0.0.0", "--port", "8080"]
