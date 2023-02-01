FROM python:2.7-slim
LABEL maintainer="ops@opentargets.org"

#need make gcc etc for requirements later
#need git to pip install from git
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    git \
    curl \
    automake \
    pkg-config \
    python-dev \
    libtool && rm -rf /var/lib/apt/lists/*;


#needed for pgrep
RUN apt-get update && apt-get install --no-install-recommends -y \
    procps && rm -rf /var/lib/apt/lists/*;

# Build Py-spy
RUN pip install --no-cache-dir py-spy

# install fresh these requirements.
# do this before copying the code to minimize image layer rebuild for dev
COPY ./requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt

#put the application in the right place
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN pip install --no-cache-dir -e .

# point to the entrypoint script fo py-spy
ENTRYPOINT [ "scripts/entrypoint.py-spy.sh" ]