FROM python:3.5
ENV PYTHONUNBUFFERED 1

# Create workdir and copy code
RUN mkdir /code
WORKDIR /code
COPY . /code/

# Install underlying debian dependencies
RUN apt-get update
RUN apt-get install --no-install-recommends curl gettext -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install --no-install-recommends nodejs build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends binutils libproj-dev gdal-bin -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean

# Install python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Install javascript dependencies
RUN npm install gulp -g && npm cache clean --force;
RUN cd /code/tools/gulp && npm install && npm cache clean --force;

# Generate and collect assets
RUN cd /code/tools/gulp && gulp
RUN python3 src/manage.py collectstatic --noinput

# Default entry point to gunicorn server, can be override by docker-compose
CMD cd src && /usr/local/bin/gunicorn sous_chef.wsgi:application -w 2 -b :8000

