FROM phusion/baseimage:latest

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install mongodb && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python python-flask python-markdown python-pymongo && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/dwwkelly/note /root/note

EXPOSE 5000

ADD note.conf.docker /root/.note.conf

ENTRYPOINT /root/note/web.py

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
