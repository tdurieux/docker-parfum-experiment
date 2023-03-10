FROM fedora:latest AS builder
LABEL maintainer='cockpit-devel@lists.fedorahosted.org'

# avoid unnecessary stuff in the container; systemd is a protected package, so apply some extra force
RUN source /etc/os-release && \
    dnf install -y --releasever=$VERSION_ID --setopt=install_weak_deps=False --installroot=/build \
        coreutils-single \
        glibc-minimal-langpack \
        nginx \
        openssh-server \
        tar \
        /usr/bin/python3 && \
    rpm --root=/build --verbose --erase --nodeps systemd && \
    dnf remove -y --installroot=/build systemd-networkd device-mapper dbus-broker cryptsetup && \
    rm -r /build/var/cache/dnf /build/var/lib/dnf /build/var/lib/rpm*

FROM scratch
COPY --from=builder /build /

RUN mkdir -p /home/user
# can't use ../sink/sink with docker build
ADD https://raw.githubusercontent.com/cockpit-project/cockpituous/main/sink/sink /home/user/sink

RUN groupadd -g 1111 -r user && useradd -r -g user -u 1111 user && \
    mkdir -p /home/user/.ssh && ln -sf /secrets/id_rsa.pub /home/user/.ssh/authorized_keys && \
    mkdir -p /home/user/.config && ln -sf /run/secrets/webhook/.config--github-token /home/user/.config/github-token && \
    ln -sf /run/config/sink /home/user/.config/sink && \
    ssh-keygen -A && \
    chmod -R ga+r /etc/ssh /home/user && \
    mkdir -p /usr/local/bin && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    rm -rf /usr/share/nginx/html && \
    ln -snf /cache/images /usr/share/nginx/html && \
    chmod -R 777 /var/log/nginx /var/lib/nginx && \
    chmod a+x /home/user/sink && \
    chmod g=u /etc/passwd

COPY install-service /usr/local/bin/
COPY nginx.conf /etc/nginx/

VOLUME /cache/images

USER user
EXPOSE 8080 8443
STOPSIGNAL SIGQUIT
CMD /usr/sbin/nginx -g "daemon off;"

# We execute the script in the host, but it doesn't exist on the host. So pipe it in
LABEL INSTALL /usr/bin/docker run -ti --rm --privileged --volume=/:/host:rw --user=root IMAGE /bin/bash -c \"/usr/sbin/chroot /host /bin/sh -s < /usr/local/bin/install-service\"

# Run a simple interactive instance of the tasks container
LABEL RUN /usr/bin/docker run -ti --rm --publish=80:8080 --publish=8493:8443 --volume=/var/lib/cockpit-secrets/tasks:/secrets:ro --volume=/var/cache/cockpit-tasks/images:/cache/images:rw IMAGE /bin/bash -i