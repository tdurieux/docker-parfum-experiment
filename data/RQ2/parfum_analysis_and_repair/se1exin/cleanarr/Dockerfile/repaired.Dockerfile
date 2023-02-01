FROM node:12 as build-stage

WORKDIR /frontend

COPY ./frontend /frontend

ENV REACT_APP_BACKEND_URL="/"

RUN yarn install && yarn build && yarn cache clean;


FROM tiangolo/uwsgi-nginx-flask:python3.7

ENV STATIC_INDEX 1
ENV CONFIG_DIR "/config"

COPY ./backend /app

COPY --from=build-stage /frontend/build /app/static
COPY --from=build-stage /frontend/build/static/css /app/static/css
COPY --from=build-stage /frontend/build/static/js /app/static/js

RUN pip install --no-cache-dir -r /app/requirements.txt
