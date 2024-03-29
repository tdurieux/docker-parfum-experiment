FROM kgyrtkirk/hive-dev-box:latest

USER root

#COPY tools/install_bazaar /tools/
#RUN /tools/install_bazaar

#COPY tools/install_executor2 /tools/
#RUN /tools/install_executor2 ${UID}

#COPY tools/install_executor3 /tools/
ARG UID=1000
#RUN /tools/install_executor3 ${UID}

COPY etc/* /etc/
COPY bin/* /bin/

VOLUME /work
VOLUME /data

COPY tools/docker_entrypoint.bazaar /.entrypoint
ENTRYPOINT ["/.entrypoint"]
CMD ["bash"]