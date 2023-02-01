FROM --platform=linux/amd64 debian:stable-slim as debian

RUN apt-get update && apt-get install --no-install-recommends -y openssh-client ca-certificates && rm -rf /var/lib/apt/lists/*;

# Create a non-privileged "nonroot" user.
RUN useradd nonroot --create-home --shell /usr/sbin/nologin
RUN chown nonroot /home/nonroot

USER nonroot:nonroot

RUN mkdir /home/nonroot/.ssh
RUN chmod 700 /home/nonroot/.ssh
RUN chmod 755 /home/nonroot

USER root
