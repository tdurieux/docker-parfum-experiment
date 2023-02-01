FROM openshift/base-centos7

MAINTAINER Luis Fernando Gomes <your@luiscoms.com.br>

ENV ERLANG_SOLUTIONS_VERSION 1.0-1
RUN yum update -y && yum clean all
RUN yum install -y wget && yum clean all
RUN yum install -y http://packages.erlang-solutions.com/erlang-solutions-${ERLANG_SOLUTIONS_VERSION}.noarch.rpm && yum clean all
RUN yum install -y erlang && yum clean all

ENV RABBITMQ_VERSION 3.6.5
RUN yum install -y http://www.rabbitmq.com/releases/rabbitmq-server/v${RABBITMQ_VERSION}/rabbitmq-server-${RABBITMQ_VERSION}-1.noarch.rpm && yum clean all
RUN echo "[{rabbit,[{loopback_users,[]}]}]." > /etc/rabbitmq/rabbitmq.config
RUN rm -rf /var/lib/rabbitmq/mnesia
EXPOSE 4369 5671 5672 25672

# get logs to stdout (thanks @dumbbell for pushing this upstream! :D)
ENV RABBITMQ_LOGS=- RABBITMQ_SASL_LOGS=-

# LABEL io.k8s.description="RabbitMQ application" \
#      io.k8s.display-name="builder x.y.z" \
#      io.openshift.expose-services="8080:http" \
#      io.openshift.tags="builder,x.y.z,etc."

# set home so that any `--user` knows where to put the erlang cookie
ENV HOME /var/lib/rabbitmq

RUN mkdir -p /var/lib/rabbitmq /etc/rabbitmq \
	&& chown -R rabbitmq:rabbitmq /var/lib/rabbitmq /etc/rabbitmq \
	&& chmod 777 /var/lib/rabbitmq /etc/rabbitmq

RUN chown -R rabbitmq:rabbitmq /opt/app-root
# && \
	# chown -R rabbitmq:rabbitmq /var/log/rabbitmq/ && \
	# chown -R rabbitmq:rabbitmq /var/lib/rabbitmq && \
	# chown -R rabbitmq:rabbitmq /etc/rabbitmq/ && \
	# chown -R rabbitmq:rabbitmq /usr/sbin/rabbitmq*
VOLUME /var/lib/rabbitmq/

RUN ls -la /var/lib/rabbitmq/

COPY ./docker-entrypoint.sh /usr/local/bin/

USER "rabbitmq"
# CMD "$STI_SCRIPTS_PATH/run"
# CMD "/docker-entrypoint.sh"
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["rabbitmq-server"]
