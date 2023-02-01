FROM docker.io/library/ubuntu:rolling

RUN DEBIAN_FRONTEND=noninteractive TZ=America/Denver apt-get update && \
    DEBIAN_FRONTEND=noninteractive TZ=America/Denver apt-get --no-install-recommends install -y \
	build-essential curl dpkg-dev ed libldap2-dev libpam0g-dev \
	libsasl2-dev libselinux1-dev libsepol-dev libssl-dev zlib1g-dev \
	libaudit-dev libssl-dev python3-dev libpython3-dev libwolfssl-dev \
	libapparmor-dev \
	file lsb-release fakeroot pkg-config procps git ssh openssh-client && rm -rf /var/lib/apt/lists/*;
RUN useradd -ms /bin/bash build
