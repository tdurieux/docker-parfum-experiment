# This is for aws deployment
###########
# BUILDER #
###########

# base image
FROM node:13.10.1-alpine as builder-react

# set working directory
WORKDIR /usr/src/app

# add `/usr/src/app/node_modules/.bin` to $PATH
ENV PATH /usr/src/app/node_modules/.bin:$PATH

# install and cache app dependencies
COPY ./services/frontend/package*.json ./
RUN npm ci
RUN npm install react-scripts@3.4.0 -g --silent && npm cache clean --force;


# set environment variables
ARG REACT_APP_BACKEND_SERVICE_URL
ENV REACT_APP_BACKEND_SERVICE_URL $REACT_APP_BACKEND_SERVICE_URL
ARG NODE_ENV
ENV NODE_ENV=production

# create build
COPY ./services/frontend/ /usr/src/app
RUN npm run build

#########
# FINAL #
#########

# base image
FROM nginx:1.17.9-alpine

#############Backend#############
# set working directory
WORKDIR /usr/src/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV FLASK_ENV=production
ENV APP_SETTINGS=app.config.ProductionConfig

# install python, postgresql, etc.
RUN apk update && \
    apk add --no-cache --virtual build-deps \
    openssl-dev libffi-dev gcc python3-dev musl-dev \
    postgresql-dev netcat-openbsd

# ensure pip3 working
RUN python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache-dir --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

# install required packages
COPY ./services/backend/requirements.txt /usr/src/app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# add backend app
COPY ./services/backend /usr/src/app

# run server
CMD gunicorn -b 0.0.0.0:5000 manage:app --daemon

############Frontend###########
# copy static files
COPY --from=builder-react /usr/src/app/build /usr/share/nginx/html

# update nginx conf
RUN rm /etc/nginx/conf.d/default.conf
COPY ./services/frontend/nginx/aws/simple/default.conf /etc/nginx/conf.d/default.conf

# expose port
EXPOSE 80

# run nginx
CMD ["nginx", "-g", "daemon off;"]
