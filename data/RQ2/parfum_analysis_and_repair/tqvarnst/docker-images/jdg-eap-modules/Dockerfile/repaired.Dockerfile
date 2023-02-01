#######################################################################
#                                                                     #
# Creates a image using JDG modules	in EAP							  #
#                                                                     #
#######################################################################

FROM    eap63:latest

MAINTAINER tqvarnst <tqvarnst@redhat.com>

#######################################################################                                                                     #
# Install JBoss JDG Moduels 										  #                                                                     #
#######################################################################
USER jbosseap

RUN mkdir -p $HOME/tmp

ADD jboss-datagrid-6.3.0-eap-modules-library.zip $HOME/tmp/

RUN /usr/bin/unzip -q $HOME/tmp/jboss-datagrid-6.3.0-eap-modules-library.zip -d $HOME/tmp/ && \
	cp -R $HOME/tmp/jboss-datagrid-6.3.0-eap-modules-library/modules/* $JBOSS_HOME/modules/

#Clean Up