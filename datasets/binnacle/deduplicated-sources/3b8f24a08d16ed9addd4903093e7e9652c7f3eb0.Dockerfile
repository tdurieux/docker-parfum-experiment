# vi:syntax=dockerfile
FROM openquake/engine
MAINTAINER Daniele Viganò <daniele@openquake.org>

ADD scripts/celery-wait.sh ${HOME}
ADD conf/openquake.cfg.cluster-sample /etc/openquake/openquake.cfg

ENTRYPOINT ["/opt/openquake/bin/python3", "-m", "celery"]
CMD ["worker", "--workdir", "/opt/openquake/lib/python3.6/site-packages/openquake/engine", "--purge", "-O", "fair"]
