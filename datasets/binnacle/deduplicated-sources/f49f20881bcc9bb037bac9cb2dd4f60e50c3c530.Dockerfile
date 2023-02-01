# vi:syntax=dockerfile
FROM openquake/base
MAINTAINER Daniele Viganò <daniele@openquake.org>

ARG oq_branch=master
ARG tools_branch=master

ENV PATH /opt/openquake/bin:$PATH
ADD https://api.github.com/repos/gem/oq-engine/git/refs/heads/$oq_branch /tmp/nocache.json
RUN pip3 -q install -r https://raw.githubusercontent.com/gem/oq-engine/$oq_branch/requirements-py36-linux64.txt \
                -r https://raw.githubusercontent.com/gem/oq-engine/$oq_branch/requirements-extra-py36-linux64.txt && \
    pip3 -q install https://github.com/gem/oq-engine/archive/$oq_branch.zip && \
    for app in oq-platform-standalone oq-platform-ipt oq-platform-taxtweb oq-platform-taxonomy; do \
        if curl --output /dev/null --silent --head --fail --location https://github.com/gem/${app}/archive/$tools_branch.zip ; then \
           pip3 -q install https://github.com/gem/${app}/archive/$tools_branch.zip; \
        else \
           pip3 -q install https://github.com/gem/${app}/archive/master.zip; \
        fi \
    done


USER openquake
ENV LANG en_US.UTF-8
ENV HOME /home/openquake
WORKDIR ${HOME}
RUN mkdir oqdata

ADD scripts/oq-start.sh ${HOME}

EXPOSE 8800:8800
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["./oq-start.sh"]
