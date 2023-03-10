# =========================================================
# === Build Static UI                                   ===
# =========================================================
FROM node:12 as builder

WORKDIR /app
COPY ui/package.json .
COPY ui/yarn.lock .
RUN yarn install --production && yarn cache clean;
COPY ui/tsconfig.json .
COPY ui/src/ ./src
COPY ui/public/ ./public
RUN yarn build

ARG GIT_LOG
RUN echo ${GIT_LOG} > ./build/static/git_sha1.txt

# =========================================================
# === Build Backend Base                                ===
# =========================================================
FROM amd64/python:3.8-slim-buster as backend-base
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*
# libgl1-mesa-glx: opencv2 libGL.so error workaround


# =========================================================
# === Build Backend Production                          ===
# =========================================================
FROM backend-base as backend-production

WORKDIR /app

RUN python -m pip install --upgrade pip

COPY backend/requirements/core.txt requirements/core.txt
RUN pip install --no-cache-dir -r ./requirements/core.txt

COPY backend/requirements/base.txt requirements/base.txt
RUN pip install --no-cache-dir -r ./requirements/base.txt

COPY backend/requirements/production-x86.txt requirements/production-x86.txt
RUN pip install --no-cache-dir -r ./requirements/production-x86.txt

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libglib2.0-0 && rm -rf /var/lib/apt/lists/*;


COPY backend/manage.py .
COPY backend/config.py .
COPY backend/vision_on_edge vision_on_edge
COPY backend/configs configs
RUN python manage.py makemigrations
RUN python manage.py migrate

COPY --from=builder /app/build vision_on_edge/ui_production
EXPOSE 8000

CMD python manage.py runserver 0.0.0.0:8000
