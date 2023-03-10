FROM mcneilco/racas-oss:develop

# RSTUDIO INSTALL
USER root
RUN yum install -y yum-plugin-ovl; rm -rf /var/cache/yum yum clean all
RUN yum install -y passwd && \
     echo "runner" | passwd --stdin runner && \
     wget https://download2.rstudio.org/rstudio-server-rhel-0.99.489-x86_64.rpm --no-verbose && \
     yum install -y --nogpgcheck rstudio-server-rhel-0.99.489-x86_64.rpm git; rm -rf /var/cache/yum yum clean all && \
     rm rstudio-server-rhel-0.99.489-x86_64.rpm

USER runner
RUN printf "R_LIBS_USER=/home/runner/build/r_libs\nR_DEFAULT_PACKAGES=\"utils,racas\"" > /home/runner/.Renviron
EXPOSE 8787
