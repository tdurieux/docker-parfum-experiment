FROM fgrehm/vagrant-ubuntu:precise

RUN apt-get update && apt-get install --no-install-recommends lxc -yq --force-yes -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sLS https://get.docker.io | sh

RUN usermod -aG docker vagrant

RUN curl -f -sLS https://raw.github.com/dotcloud/docker/master/hack/dind -o /dind && \
    chmod +x /dind

CMD ["/dind", "/sbin/init"]
