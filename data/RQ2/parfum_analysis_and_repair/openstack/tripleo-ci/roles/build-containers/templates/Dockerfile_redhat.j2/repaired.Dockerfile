FROM {{ base_ubi_image }}:{{ base_ubi_tag }}
RUN rm -f /etc/yum.repos.d/delorean*
COPY repos/* /etc/yum.repos.d/.
RUN dnf clean all