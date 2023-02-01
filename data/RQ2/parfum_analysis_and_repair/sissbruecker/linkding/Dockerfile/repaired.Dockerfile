FROM node:current-alpine AS node-build
WORKDIR /etc/linkding
# install build dependencies
COPY package.json package-lock.json ./
RUN npm install -g npm && \
    npm install && npm cache clean --force;
# compile JS components
COPY . .
RUN npm run build


FROM python:3.9.6-slim-buster AS python-base
RUN apt-get update && apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
WORKDIR /etc/linkding


FROM python-base AS python-build
# install build dependencies
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -U pip && pip install --no-cache-dir -Ur requirements.txt
# run Django part of the build
COPY --from=node-build /etc/linkding .
RUN python manage.py compilescss && \
    python manage.py collectstatic --ignore=*.scss && \
    python manage.py compilescss --delete-files


FROM python-base AS prod-deps
COPY requirements.prod.txt ./requirements.txt
RUN mkdir /opt/venv && \
    python -m venv --upgrade-deps --copies /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip wheel && \
    /opt/venv/bin/pip install -Ur requirements.txt


FROM python:3.9.6-slim-buster as final
RUN apt-get update && apt-get -y --no-install-recommends install mime-support && rm -rf /var/lib/apt/lists/*;
WORKDIR /etc/linkding
# copy prod dependencies
COPY --from=prod-deps /opt/venv /opt/venv
# copy output from build stage
COPY --from=python-build /etc/linkding/static static/
# copy application code
COPY . .
# Expose uwsgi server at port 9090
EXPOSE 9090
# Activate virtual env
ENV VIRTUAL_ENV /opt/venv
ENV PATH /opt/venv/bin:$PATH
# Allow running containers as an an arbitrary user in the root group, to support deployment scenarios like OpenShift, Podman
RUN ["chmod", "g+w", "."]
# Run bootstrap logic
RUN ["chmod", "+x", "./bootstrap.sh"]
CMD ["./bootstrap.sh"]
