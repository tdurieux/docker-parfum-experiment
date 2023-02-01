ARG BASE_IMAGE=3.7-apline
FROM alpine as intermediate

RUN apk update && apk add --no-cache wget gcc build-base libxt-dev libx11-dev xorg-server-dev libxmu-dev libxaw-dev bdftopcf ncurses-dev tcl tcl-dev mkfontdir && \
	wget https://x3270.bgp.nu/download/03.06/suite3270-3.6ga5-src.tgz && \
	tar xzvf suite3270-3.6ga5-src.tgz && \
	cd suite3270-3.6 && \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
	make x3270 && rm suite3270-3.6ga5-src.tgz

FROM python:${BASE_IMAGE}

COPY --from=intermediate /suite3270-3.6/obj/x86_64-unknown-linux-gnu/x3270 /usr/lib/x3270

RUN apk update && apk add xvfb libxaw && rm -rf /var/cache/apk/* && \
    pip install --no-cache-dir robotframework six robotremoteserver && \
	mkdir /reports
RUN	ln -s /usr/lib/x3270/x3270 /usr/bin/x3270
ARG PYTHON_MAJOR
COPY source /usr/local/lib/python${PYTHON_MAJOR}.7/site-packages/Mainframe3270
COPY entrypoint.sh .
COPY tests /tests
WORKDIR reports

ENTRYPOINT ["/entrypoint.sh"]