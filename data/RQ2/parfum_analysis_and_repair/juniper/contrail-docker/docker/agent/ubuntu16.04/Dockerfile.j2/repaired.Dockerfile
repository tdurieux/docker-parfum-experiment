FROM contrail-base-{{ OS }}:{{ contrail_version }}
LABEL Name=contrail-agent-{{ OS }}\
      Version={{ CONTRAIL_VERSION }} \
      contrail.role=agent \
      Description="Contrail Vrouter Agent" Vendor="Juniper Networks"
ENV CONTRAIL_ROLE agent
RUN echo $CONTRAIL_ROLE > /etc/contrail-role
RUN contrailctl config sync -F -v -t package
RUN contrailctl config sync -F -v -t install
EXPOSE 8085 9090
RUN cp -rf /usr/src/ /usr/src.orig/
RUN rm -rf /etc/apt/sources.list.d/xenial.list
RUN rm -rf /etc/apt/sources.list.d/xenial-updates.list
RUN rm -rf /etc/apt/sources.list.d/xenial-security.list
RUN rm -rf /etc/apt/sources.list.d/contrail-ansible-packages-xenial.list
RUN rm -rf /etc/apt/sources.list.d/contrail-local.list
RUN apt-get clean; apt-get update; echo 0