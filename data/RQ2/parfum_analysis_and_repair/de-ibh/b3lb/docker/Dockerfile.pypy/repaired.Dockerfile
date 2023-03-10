# B3LB - BigBlueButton Load Balancer
# Copyright (C) 2020-2021 IBH IT-Service GmbH
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or (at your
# option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License
# for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.


FROM pypy:3.7-7.3.5-slim AS build

RUN apt-get update && apt-get install --no-install-recommends -y build-essential libpq-dev && rm -rf /var/lib/apt/lists/*;

ENV PYTHONUNBUFFERED 1

WORKDIR /usr/src/app

COPY b3lb/requirements.txt ./
RUN pip3 install --no-cache-dir --prefix=/usr/local -r requirements.txt


FROM pypy:3.7-7.3.5-slim

RUN apt-get update && apt-get install --no-install-recommends -y libpq5 && rm -rf /var/lib/apt/lists/*;

ARG B3LBUID=8318
ENV PYTHONUNBUFFERED 1
ENV PYTHONPATH /usr/local/site-packages

WORKDIR /usr/src/app

COPY --from=build /usr/local /usr/local

COPY b3lb/manage.py \
     b3lb/loadbalancer/.env.dev \
     docker/entrypoint.sh \
     docker/static.sh \
     ./
COPY b3lb/loadbalancer ./loadbalancer
COPY b3lb/rest ./rest

RUN addgroup --gid $B3LBUID b3lb && \
    adduser --uid $B3LBUID --gid $B3LBUID --home /usr/src/app --disabled-password --no-create-home --system b3lb && \
    ln -s $(which pypy3) /usr/local/bin/python3 && \
    ENV_FILE=.env.dev ./manage.py check --force-color && \
    ENV_FILE=.env.dev ./manage.py collectstatic --no-input --force-color

USER b3lb:b3lb
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
CMD ["uvicorn", "--host", "0.0.0.0", "--ws", "none", "--no-access-log", "--use-colors"]
