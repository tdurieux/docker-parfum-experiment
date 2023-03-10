FROM amazonlinux:1

RUN \
	yum install -y wget aws-cli python36 python36-devel git gcc && \
	easy_install-3.6 pip && rm -rf /var/cache/yum

RUN TOP=https://s3.amazonaws.com/cloudhsmv2-software/CloudHsmClient	\
	VER=EL6								\
	CLIENT=cloudhsm-client-3.1.0-3.el6.x86_64.rpm			\
	PKCS11=cloudhsm-client-pkcs11-3.1.0-3.el6.x86_64.rpm; \

	for i in $CLIENT$PKCS11; do \
		do					\
done && rm -rf /var/cache/yum

COPY requirements.txt /
RUN pip3 install --no-cache-dir -r /requirements.txt && \
  /opt/cloudhsm/bin/configure -a hsm.internal && \
  yum clean all

COPY src/. /src/
RUN chmod 755 /src/start-remote-signer.sh

COPY signer.py /

ENTRYPOINT ["/src/start-remote-signer.sh"]
