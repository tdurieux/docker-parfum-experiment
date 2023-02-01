# Use an official Python runtime as a parent image
FROM python:latest

# Install curl, node, & yarn
RUN apt-get -y --no-install-recommends install curl \
  && curl -f -sL https://deb.nodesource.com/setup_14.x | bash \
  && apt-get install -y --no-install-recommends nodejs \
  && curl -f -o- -L https://yarnpkg.com/install.sh | bash && rm -rf /var/lib/apt/lists/*;

WORKDIR /app/backend

# Install Python dependencies
COPY ./backend/requirements /app/backend/requirements
RUN pip install --no-cache-dir -r requirements/production.txt

# Install JS dependencies
WORKDIR /app/frontend

COPY ./frontend/package.json /app/frontend/
RUN $HOME/.yarn/bin/yarn install

# Add the rest of the code
COPY . /app

# Build static files
RUN $HOME/.yarn/bin/yarn build

# Have to move all static files other than index.html to root/
# for whitenoise middleware
WORKDIR /app/frontend/build

RUN mkdir root && mv *.ico *.js *.json root

# Collect static files
RUN mkdir /app/backend/staticfiles

WORKDIR /app

# SECRET_KEY is only included here to avoid raising an error when generating static files
RUN DJANGO_SETTINGS_MODULE=backend.settings.production \
  SECRET_KEY=somethingsupersecret \
  python backend/manage.py collectstatic --noinput

EXPOSE $PORT

CMD python3 backend/manage.py runserver 0.0.0.0:$PORT
