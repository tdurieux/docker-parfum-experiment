FROM @@IMAGE@@
ADD install_deps.sh install_deps.sh
RUN ./install_deps.sh
ADD scylla.repo /etc/yum.repos.d/scylla.repo
CMD /bin/bash