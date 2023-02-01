FROM python:3.6

RUN apt-get update && apt-get install --no-install-recommends -y \
  proj-bin \
  libproj-dev \
  libgeos-dev && rm -rf /var/lib/apt/lists/*;

COPY ./requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install --no-cache-dir -r /app/requirements.txt

COPY ./data/GIS /app/data/GIS
COPY ./data/line_info /app/data/line_info
COPY ./tests /app/tests
COPY ./tasks /app/tasks
COPY ./src /app/src
