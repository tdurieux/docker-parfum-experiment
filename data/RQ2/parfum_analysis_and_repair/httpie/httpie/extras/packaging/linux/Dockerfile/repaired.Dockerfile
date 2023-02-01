# Use the oldest (but still supported) Ubuntu as the base for PyInstaller
# packages. This will prevent stuff like glibc from conflicting.
FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common binutils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ruby-dev && rm -rf /var/lib/apt/lists/*;
RUN gem install fpm

# Use deadsnakes for the latest Pythons (e.g 3.9)
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update && apt-get install --no-install-recommends -y python3.9 python3.9-dev python3.9-venv && rm -rf /var/lib/apt/lists/*;

# Install rpm as well, since we are going to build fedora dists too
RUN apt-get install --no-install-recommends -y rpm && rm -rf /var/lib/apt/lists/*;

ADD . /app
WORKDIR /app/extras/packaging/linux

ENV VIRTUAL_ENV=/opt/venv
RUN python3.9 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Ensure that pip is renewed, otherwise we would be using distro-provided pip
# which strips vendored packages and doesn't work with PyInstaller.
RUN python -m pip install /app
RUN python -m pip install pyinstaller wheel
RUN python -m pip install --force-reinstall --upgrade pip

RUN echo 'BUILD_CHANNEL="pypi"' > /app/httpie/internal/__build_channel__.py
RUN python build.py

ENTRYPOINT ["mv", "/app/extras/packaging/linux/dist/", "/artifacts"]
