ARG registry
FROM $registry/labtainer.network
LABEL description="This is base Docker image for Juice shop serviers"
ARG lab
RUN cp /var/tmp/sources.list /etc/apt/sources.list
RUN apt update && apt install --no-install-recommends -y build-essential apt-transport-https lsb-release ca-certificates curl npm git nano sqlite3 apt-utils && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
RUN apt install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
#
RUN wget https://github.com/bkimminich/juice-shop/releases/download/v11.1.2/juice-shop-11.1.2_node14_linux_x64.tgz
RUN tar -xf /juice*
RUN rm /juice*.tgz
