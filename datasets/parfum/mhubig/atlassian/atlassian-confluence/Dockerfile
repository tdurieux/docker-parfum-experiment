FROM relateiq/oracle-java8

ENV CONFLUENCE_VERSION 5.8.6
ENV CONFLUENCE_HOME /opt/confluence-home
ENV HOME /opt/confluence-home

RUN mkdir /opt/confluence && \
    mkdir /opt/confluence-home
RUN wget -O - \
    http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${CONFLUENCE_VERSION}.tar.gz \
        | tar xzf - --strip=1 -C /opt/confluence \
    && perl -i -p -e 's/-Xms512m/-Xms128m/' /opt/confluence/bin/setenv.sh \
    && perl -i -p -e 's/-Xmx2048m/-Xmx512m/' /opt/confluence/bin/setenv.sh \
    && perl -i -p -e 's/_%T//' /opt/confluence/bin/setenv.sh \
    && echo "confluence.home = ${CONFLUENCE_HOME}" > \
        /opt/confluence/confluence/WEB-INF/classes/confluence-init.properties

WORKDIR /opt/confluence
VOLUME ["/opt/confluence-home"]

CMD ["/opt/confluence/bin/catalina.sh", "run"]
