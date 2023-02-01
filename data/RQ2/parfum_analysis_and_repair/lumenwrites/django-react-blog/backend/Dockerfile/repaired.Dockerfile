FROM ubuntu:latest
# Set the file maintainer (your name - the file's author)
MAINTAINER Ray Alez

ENV HOMEDIR=/home
ENV PROJECTDIR=/home/blog
ENV BACKENDDIR=/home/blog/backend

# Install basic apps
RUN apt-get update && apt-get install --no-install-recommends -y git emacs curl iputils-ping && rm -rf /var/lib/apt/lists/*;

# Install python/django dependencies 	        	   
RUN apt-get install --no-install-recommends -y python3-dev python3-pip build-essential supervisor nginx libpq-dev uwsgi-plugin-python3 libcurl4-openssl-dev supervisor && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U pip setuptools
RUN pip3 install --no-cache-dir uwsgi

# Copy and Install requirements
# (before copying the rest of the code, so docker would cache them and not reinstall)
WORKDIR $BACKENDDIR
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy all project files	
COPY . .

# Serve it with nginx/uwsgi    	
# https://github.com/dockerfiles/django-uwsgi-nginx
# tutorial: https://uwsgi.readthedocs.org/en/latest/tutorials/Django_and_nginx.html	
RUN echo "daemon off;" >> /etc/nginx/nginx.conf    	
COPY config/backend_nginx.conf /etc/nginx/sites-available/default
COPY config/supervisor.conf /etc/supervisor/conf.d
COPY config/uwsgi.ini $PROJECTDIR
COPY config/uwsgi_params $PROJECTDIR

# Migrate (not sure if it works)
CMD [ "python3.5", "./manage.py migrate" ]           
# Start supervisor
CMD ["supervisord", "-n"]
