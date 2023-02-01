# build image to extract the tar ball.
FROM ubuntu:16.04 as builder
 ARG WAS_VERSION=9.0.0.11
 ARG WAS_TAR_BALL=was-${WAS_VERSION}.tar.gz
COPY im/${WAS_TAR_BALL} /
RUN tar -xzf "$WAS_TAR_BALL"
# patch wsadmin.sh to avoid error when deploying apps
RUN sed -i 's/-Xms256m/-Xms1024m/g' /opt/IBM/WebSphere/AppServer/bin/wsadmin.sh \
    && sed -i 's/-Xmx256m/-Xmx1024m/g' /opt/IBM/WebSphere/AppServer/bin/wsadmin.sh \
    && chmod -R g+rw /opt/IBM


# final image that will copy extracted tar ball from builder
FROM ubuntu:16.04
ARG USER=was

ARG PROFILE_NAME=AppSrv01
ARG CELL_NAME=DefaultCell01
ARG NODE_NAME=DefaultNode01
ARG HOST_NAME=localhost
ARG SERVER_NAME=server1
ARG ADMIN_USER_NAME=wsadmin

COPY scripts/ /work/
COPY licenses /licenses/


RUN apt-get update && apt-get install -y openssl

RUN useradd $USER -g 0 -m --uid 1001 \
  && mkdir /opt/IBM \
  && chmod -R +x /work/* \
  && mkdir /etc/websphere \
  && mkdir /work/config \
  && chown -R 1001:0 /work /opt/IBM /etc/websphere

COPY --chown=1001:0 --from=builder /opt/IBM /opt/IBM

USER $USER

ENV PATH=/opt/IBM/WebSphere/AppServer/bin:$PATH \
    PROFILE_NAME=$PROFILE_NAME \
    SERVER_NAME=$SERVER_NAME \
    ADMIN_USER_NAME=$ADMIN_USER_NAME \
    EXTRACT_PORT_FROM_HOST_HEADER=true

RUN /work/create_profile.sh \
  && find /opt/IBM -user was ! -perm -g=w -print0 | xargs -0 chmod g+w \
  && chmod -R g+rwx /home/was/.java/

USER root
RUN ln -s /opt/IBM/WebSphere/AppServer/profiles/${PROFILE_NAME}/logs /logs && chown 1001:0 /logs
USER $USER

CMD ["/work/start_server.sh"]

