FROM bcgovimages/von-image:py36-1.11-1

USER indy

RUN mkdir src test-reports

WORKDIR /home/indy/src

RUN mkdir -p test-reports

ADD requirements.txt requirements.dev.txt ./

RUN pip3 install --no-cache-dir \
	-r requirements.txt \
	-r requirements.dev.txt

ADD --chown=indy:root . .

ENTRYPOINT ["/bin/bash", "-c", "pytest \"$@\"", "--"]