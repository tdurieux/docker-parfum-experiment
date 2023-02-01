FROM armhf/ubuntu
RUN apt-get -qq update && \
  apt-get -qy --no-install-recommends install redis-server && rm -rf /var/lib/apt/lists/*;
USER root
#RUN echo "vm.overcommit_memory = 1'" |tee -a /etc/sysctl.conf
EXPOSE 6379
CMD ["redis-server"]
