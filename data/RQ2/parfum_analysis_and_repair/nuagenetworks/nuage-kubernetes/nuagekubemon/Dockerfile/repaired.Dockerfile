FROM registry.access.redhat.com/ubi8/ubi:latest

ADD nuagekubemon /usr/bin/nuagekubemon
ADD nuage-openshift-monitor /usr/bin/nuage-openshift-monitor
ADD configure-master.sh /configure-master.sh

CMD ["/configure-master.sh"]