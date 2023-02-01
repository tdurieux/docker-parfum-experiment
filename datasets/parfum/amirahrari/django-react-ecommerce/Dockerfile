FROM node:12.2.0-alpine as build

RUN mkdir -p /tmp/react

ADD package.json /tmp/package.json
RUN cd /tmp && npm install
RUN cp -a /tmp/node_modules /tmp/react

WORKDIR /tmp/react
COPY . /tmp/react
RUN npm run build

FROM python:3.8.0-alpine

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

ENV APP_HOME=/home/app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN apk update
RUN apk --update add gcc libgcc musl-dev jpeg-dev zlib-dev postgresql-dev

COPY ./requirements.txt .
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

COPY . $APP_HOME
COPY --from=build /tmp/react/dist $APP_HOME/dist

CMD python manage.py collectstatic --no-input --clear

ENTRYPOINT ["/home/app/entrypoint.sh"]