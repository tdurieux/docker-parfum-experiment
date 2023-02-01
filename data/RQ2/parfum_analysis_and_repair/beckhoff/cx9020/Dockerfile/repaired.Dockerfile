from ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y sudo gpg && rm -rf /var/lib/apt/lists/*;
COPY tools/10_prepare_host_ubuntu1804.sh /prepare.sh
RUN /prepare.sh
RUN git config --global user.name "gitlab-runner"
RUN git config --global user.email "gitlab-runner@example.com"
