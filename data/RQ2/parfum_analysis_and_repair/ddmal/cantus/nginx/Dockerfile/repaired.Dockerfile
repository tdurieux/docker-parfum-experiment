FROM node:10 AS frontend
COPY ./public/node /code
RUN npm install -g gulp && npm cache clean --force;

WORKDIR /code/frontend
RUN npm install && npm cache clean --force;
RUN gulp build --release

FROM python:3.6.9 AS django-static
COPY ./public/python /code

WORKDIR /code
RUN pip install --no-cache-dir -r requirements.txt
RUN python manage.py collectstatic --noinput

FROM nginx
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY --from=frontend /code/static /code/static
COPY --from=django-static /code/cantusdata/static /code/static