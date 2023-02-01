# pull official base image
FROM python:3.9-slim-bullseye

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# set work directory
WORKDIR /usr/src/app

# copy entrypoint.sh
COPY ./entrypoint.prod.sh /usr/src/app/entrypoint.prod.sh

# Copy dependencies file
COPY requirements.txt .

# installing netcat (nc) since we are using that to listen to postgres server in entrypoint.sh
RUN apt-get update && apt-get install -y --no-install-recommends netcat && \
    apt-get install --no-install-recommends ffmpeg libsm6 libxext6 -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir -r requirements.txt

# copy our django project
COPY ./backend_apps .

# run entrypoint.sh
ENTRYPOINT ["/usr/src/app/entrypoint.prod.sh"]
