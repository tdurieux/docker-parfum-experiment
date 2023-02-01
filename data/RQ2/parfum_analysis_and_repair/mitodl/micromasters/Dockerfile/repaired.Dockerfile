FROM python:3.9-buster
LABEL maintainer "ODL DevOps <mitx-devops@mit.edu>"


# Add package files, install updated node and pip
WORKDIR /tmp

COPY apt.txt /tmp/apt.txt
RUN apt-get update
RUN apt-get install --no-install-recommends -y $(grep -vE "^\s*#" apt.txt  | tr "\n" " ") && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends libpq-dev postgresql-client -y && rm -rf /var/lib/apt/lists/*;

# pip
RUN curl -f --silent --location https://bootstrap.pypa.io/get-pip.py | python3 -

# Add, and run as, non-root user.
RUN mkdir /src
RUN adduser --disabled-password --gecos "" mitodl
RUN mkdir /var/media && chown -R mitodl:mitodl /var/media

# Install project packages
COPY *requirements.txt /tmp/
RUN pip install --no-cache-dir -r requirements.txt -r

# Add project
COPY . /src
WORKDIR /src
RUN chown -R mitodl:mitodl /src

RUN apt-get clean && apt-get purge
USER mitodl

# Set pip cache folder, as it is breaking pip when it is on a shared volume
ENV XDG_CACHE_HOME /tmp/.cache

EXPOSE 8079
ENV PORT 8079
CMD uwsgi uwsgi.ini
