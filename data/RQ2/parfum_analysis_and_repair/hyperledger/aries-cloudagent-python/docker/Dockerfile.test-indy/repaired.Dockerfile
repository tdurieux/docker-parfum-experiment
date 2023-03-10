FROM bcgovimages/von-image:py36-1.15-1

USER indy

RUN mkdir src test-reports

WORKDIR /home/indy/src

RUN mkdir -p test-reports && chown -R indy:indy test-reports && chmod -R ug+rw test-reports

ADD requirements*.txt ./

RUN pip3 install --no-cache-dir \
	-r requirements.txt \
	-r requirements.askar.txt \
	-r requirements.bbs.txt \
	-r requirements.dev.txt

ADD --chown=indy:root . .

ENTRYPOINT ["/bin/bash", "-c", "pytest \"$@\"", "--"]