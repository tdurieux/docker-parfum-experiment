ARG BASE_DIGEST
FROM cyph/base@${BASE_DIGEST}
ARG BASE_DIGEST
LABEL BASE_DIGEST="${BASE_DIGEST}"

COPY .local-docker-context /home/gibson/.local-docker-context

RUN sudo bash -c ' \
	cd /home/gibson ; \
	if [ -d .local-docker-context/config ] ; then \
		rm -rf .config &> /dev/null ; \
		mv .local-docker-context/config .config &> /dev/null ; \
		rm -rf .local-docker-context &> /dev/null ; \
		chown -R gibson .config &> /dev/null ; \
		chmod -R 700 .config &> /dev/null ; \
	fi \
'

WORKDIR /cyph/commands
CMD /bin/bash