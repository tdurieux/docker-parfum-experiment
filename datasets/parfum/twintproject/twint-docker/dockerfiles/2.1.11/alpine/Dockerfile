FROM alpine:3.11 AS build

ARG TWINT_VERSION=v2.1.11

WORKDIR /opt/app

# Install Python and external dependencies, including headers and GCC
RUN apk add --no-cache python3 python3-dev py3-pip libffi libffi-dev musl-dev gcc git ca-certificates openblas-dev musl-dev g++

# Install Pipenv
RUN pip3 install pipenv

# Create a virtual environment and activate it
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH" \
	VIRTUAL_ENV="/opt/venv"

# Install dependencies into the virtual environment with Pipenv
RUN git clone --depth=1 -b v2.1.11 https://github.com/twintproject/twint /opt/app \
	&& cd /opt/app \
	&& pip3 install --upgrade pip \
	&& pip3 install cython \
	&& pip3 install numpy \
	&& pip3 install .

FROM alpine:3.11
MAINTAINER x0rxkov <x0rxkov@protonmail.com>

ARG VERSION=${VERSION:-"v2.1.11"}
ARG BUILD
ARG NOW

# Create runtime user
RUN mkdir -p /opt \
	&& adduser -D twint -h /opt/app -s /bin/sh \
 	&& su twint -c 'cd /opt/app; mkdir -p data'

# Install Python and external runtime dependencies only
RUN apk add --no-cache python3 libffi openblas libstdc++

# Switch to user context
USER twint
WORKDIR /opt/twint/data

# Copy the virtual environment from the previous image
COPY --from=build /opt/venv /opt/venv

# Activate the virtual environment
ENV PATH="/opt/venv/bin:$PATH" \
	VIRTUAL_ENV="/opt/venv"

LABEL name="twint" \
      version="$VERSION" \
      build="$BUILD" \
      architecture="x86_64" \
      build_date="$NOW" \
      vendor="twintproject" \
      maintainer="x0rzkov <x0rzkov@protonmail.com>" \
      url="https://github.com/twintproject/twint-docker" \
      summary="Dockerized twint project" \
      description="Dockerized twint project" \
      vcs-type="git" \
      vcs-url="https://github.com/twintproject/twint-docker" \
      vcs-ref="$VERSION" \
      distribution-scope="public"

ENTRYPOINT ["twint"]