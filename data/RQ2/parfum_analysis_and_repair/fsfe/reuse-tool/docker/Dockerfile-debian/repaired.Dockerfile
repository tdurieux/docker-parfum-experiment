# SPDX-FileCopyrightText: 2021 Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# Like normal Dockerfile, but based on python:slim (Debian) to ease compliance

# Create a base image that has dependencies installed.
FROM python:slim AS base

RUN apt-get update \
    && apt-get install --no-install-recommends -y git mercurial \
    && rm -rf /var/lib/apt/lists/*

# Build reuse into a virtualenv
FROM base AS build

WORKDIR /reuse-tool

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY . /reuse-tool/

RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir .


# Copy over the virtualenv and use it
FROM base
COPY --from=build /opt/venv /opt/venv

ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

WORKDIR /data

ENTRYPOINT ["reuse"]
CMD ["lint"]
