# This stage builds a dist tarball from the source
FROM d_base:latest as source-builder

# Specify what version of frr should be built.
# ARG FRR_VERSION=7.2.1
ARG FRR_VERSION=7.5.1

RUN mkdir /src

RUN wget "https://github.com/FRRouting/frr/archive/refs/tags/frr-${FRR_VERSION}.tar.gz" -O - | tar -xz --strip-components=1 --directory /src

RUN source /src/alpine/APKBUILD.in \
	&& apk add \
		--no-cache \
		--update-cache \
		$makedepends \
		gzip \
	&& pip install --no-cache-dir pytest

RUN cd /src \
	&& ./bootstrap.sh \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
		--enable-numeric-version \
		--with-pkg-extra-version="_git$FRR_VERSION" \
	&& make dist

# This stage builds an apk from the dist tarball
FROM d_base:latest as alpine-builder
# Don't use nocache here so that abuild can use the cache
RUN apk add --no-cache \
		--update-cache \
		abuild \
		alpine-conf \
		alpine-sdk \
		py-pip \
	&& pip install --no-cache-dir pytest \
	&& setup-apkcache /var/cache/apk \
	&& mkdir -p /pkgs/apk \
	&& echo 'builder ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY --from=source-builder /src/frr-*.tar.gz /src/alpine/* /dist/
RUN adduser -D -G abuild builder && chown -R builder /dist /pkgs
USER builder
RUN cd /dist \
	&& abuild-keygen -a -n \
	&& abuild checksum \
	&& git init \
	&& abuild -r -P /pkgs/apk

# This stage installs frr from the apk
FROM d_base_supervisor:latest
RUN mkdir -p /pkgs/apk
COPY --from=alpine-builder /pkgs/apk/ /pkgs/apk/
RUN apk add \
		--no-cache \
		--update-cache \
		tini \
	&& apk add \
		--no-cache \
		--allow-untrusted /pkgs/apk/*/*.apk \
	&& rm -rf /pkgs

RUN apk add --no-cache openssh-server frr frr-rpki frr-pythontools \
    && ssh-keygen -A \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config \
    && sed -i 's/#PrintMotd yes/PrintMotd no/g' /etc/ssh/sshd_config \
    # Unlocks the root user so that ssh login is allowed.
    && sed -i s/root:!/"root:*"/g /etc/shadow \
    && mkdir -p /var/run/sshd /root/.ssh \
    && chmod 0755 /var/run/sshd

RUN install -m 755 -o frr -g frr -d /var/log/frr \
    && install -m 755 -o frr -g frr -d /var/run/frr \
    && install -m 775 -o frr -g frrvty -d /etc/frr \
    && install -m 640 -o frr -g frr /dev/null /etc/frr/zebra.conf \
    && install -m 640 -o frr -g frr /dev/null /etc/frr/bgpd.conf \
    && install -m 640 -o frr -g frr /dev/null /etc/frr/ospfd.conf \
    && install -m 640 -o frr -g frr /dev/null /etc/frr/ospf6d.conf \
    && install -m 640 -o frr -g frr /dev/null /etc/frr/isisd.conf \
    && install -m 640 -o frr -g frr /dev/null /etc/frr/ripd.conf \
    && install -m 640 -o frr -g frr /dev/null /etc/frr/ripngd.conf \
    && install -m 640 -o frr -g frr /dev/null /etc/frr/pimd.conf \
    && install -m 640 -o frr -g frr /dev/null /etc/frr/ldpd.conf \
    && install -m 640 -o frr -g frr /dev/null /etc/frr/nhrpd.conf \
    && install -m 640 -o frr -g frrvty /dev/null /etc/frr/vtysh.conf

EXPOSE 22

COPY supervisord.conf /etc/supervisor/conf.d/processes.conf
COPY looking_glass.sh /usr/local/bin/looking_glass
COPY run_frr.sh /usr/local/bin/run_frr

RUN chmod +x /usr/local/bin/looking_glass /usr/local/bin/run_frr
