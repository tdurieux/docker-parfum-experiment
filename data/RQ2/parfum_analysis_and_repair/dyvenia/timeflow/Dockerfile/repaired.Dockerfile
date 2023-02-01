FROM node:alpine
RUN npm install -g npm && npm cache clean --force;
# RUN npm install -g npx
RUN npm install -g -D tailwindcss postcss autoprefixer && npm cache clean --force;
RUN npx tailwindcss init

FROM python:3.8
COPY ./ /applications/
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt && \
    python -m pip install watchdog