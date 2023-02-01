ARG     OS_RELEASE
FROM    pidtree-docker-base-${OS_RELEASE}

# Focal doesn't have dh-virtualenv in default repos
# so we install it from the maintainer's PPA
RUN if grep focal /etc/lsb-release; then \
            apt-get update \
            && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install software-properties-common \
            && add-apt-repository ppa:jyrki-pulliainen/dh-virtualenv; rm -rf /var/lib/apt/lists/*; \
        fi

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install \
            python3 \
            python3-pip \
            dh-virtualenv \
            dh-make \
            build-essential \
            debhelper \
            devscripts \
            equivs \
            libyaml-dev \
        && apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /work

# we need to backpin system level six to force virtualenv to reinstall
# a local copy when packaging, otherwise it won't be included in the .deb
RUN if grep jammy /etc/lsb-release; then \
            pip3 install --no-cache-dir --force-reinstall six==1.15.0; \
        fi

ADD     . /work
ADD     packaging/debian /work/debian

CMD     /work/packaging/debian.sh
