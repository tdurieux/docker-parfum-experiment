FROM amazonlinux:2
MAINTAINER jeancharlesjorel@gmail.com

# Force full rebuild on version change
ADD VERSION.txt /

RUN yum upgrade -y && \
    yum install git curl wget python3 jq shadow-utils sudo tar which procps-ng vim httpd-tools \
	mtr iputils bind-utils time dialog uuid -y && \
	yum clean all && rm -rf /var/cache/yum
RUN bash -c "curl https://bootstrap.pypa.io/get-pip.py | python3" && \
	/usr/local/bin/pip3 install jinja2 awscli awscurl pythondialog && \
	pip install --no-cache-dir aws-sam-cli aws-xray-sdk requests-iamauth crudini
RUN groupadd -g 1000 ec2-user && adduser -u 1000 -g 1000 ec2-user
ENV HOME=/home/ec2-user
COPY build/bashrc /etc/bashrc.clonesquad
RUN  cat /etc/bashrc.clonesquad >>/etc/bashrc && rm -f /etc/bashrc.clonesquad

ENV CLONESQUAD_DIR=/clonesquad
ENV CLONESQUAD_DEPENDENCY_DIR=${CLONESQUAD_DIR}/.venv/lib/python3.7/site-packages/
ENV CLONESQUAD_PARAMETER_DIR=/clonesquad-deployment-parameters/
RUN mkdir -p ${CLONESQUAD_DIR} ${CLONESQUAD_PARAMETER_DIR} && \
	chown -R ec2-user.ec2-user $CLONESQUAD_DIR && \
	chown -R ec2-user.ec2-user $CLONESQUAD_PARAMETER_DIR && \
	ln -s ${CLONESQUAD_PARAMETER_DIR}/.bash_history ${HOME}/.bash_history

USER ec2-user
ENV PATH="${PATH}:/clonesquad/scripts:/clonesquad/tools"
WORKDIR ${CLONESQUAD_DIR}
ENV PYTHONPATH=${CLONESQUAD_DEPENDENCY_DIR}
COPY build/clonesquad-paremeters-templates/ ${CLONESQUAD_PARAMETER_DIR}
COPY --chown=ec2-user:ec2-user . .
RUN ./scripts/update-python-requirements


