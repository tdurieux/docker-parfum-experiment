FROM python:3.8-slim AS compile-image

RUN apt-get update && apt install --no-install-recommends -y \

    libpq-dev \
    python3-dev \
    python3-pip && rm -rf /var/lib/apt/lists/*;

# Set working directory
WORKDIR /usr/src/app

# Make and use virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install dependencies
RUN pip3 install --no-cache-dir --upgrade pip
COPY ./requirements.txt /usr/src/app/requirements.txt
COPY ./setup.py /usr/src/app/setup.py
COPY ./VERSION /usr/src/app/VERSION
COPY ./README.md /usr/src/app/README.md
RUN mkdir /usr/src/app/backend && rm -rf /usr/src/app/backend
RUN mkdir /usr/src/app/webtool && rm -rf /usr/src/app/webtool
RUN mkdir /usr/src/app/datasources && rm -rf /usr/src/app/datasources
RUN pip3 install --no-cache-dir -r requirements.txt

# Install frontend Docker requirements
RUN pip3 install --no-cache-dir gunicorn

# Build image from compile-image
FROM python:3.8-slim AS build-image
COPY --from=compile-image /opt/venv /opt/venv
# Make virtual env available
ENV PATH="/opt/venv/bin:$PATH"

RUN apt-get update && apt install --no-install-recommends -y \

    curl \
    netcat \
    postgresql-client \
    postgresql-server-dev-all \

    git && rm -rf /var/lib/apt/lists/*;

# Set working directory
WORKDIR /usr/src/app

# Copy project
COPY . /usr/src/app/

# Permission
RUN chmod +x docker/wait-for-backend.sh docker/docker-entrypoint.sh
