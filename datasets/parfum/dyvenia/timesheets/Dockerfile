FROM node:alpine
RUN npm install -g npm
# RUN npm install -g npx
RUN npm install -g -D tailwindcss postcss autoprefixer
RUN npx tailwindcss init

FROM python:3.8
COPY ./ /applications/
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt && \
    python -m pip install watchdog