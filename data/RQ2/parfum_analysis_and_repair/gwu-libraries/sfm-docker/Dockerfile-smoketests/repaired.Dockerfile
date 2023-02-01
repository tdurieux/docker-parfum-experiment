# gwul/sfm-base:2.4.0
FROM gwul/sfm-base@sha256:0b80a3d3562cdb4d631fbb55b9bd24889312838cbd27cd33e14cc0c18405f007
MAINTAINER Social Feed Manager <sfm@gwu.edu>

ENV GECKODRIVER_VER v0.30.0
RUN apt-get update && apt-get install --no-install-recommends -y \
    wget \
    iceweasel \
    xvfb && rm -rf /var/lib/apt/lists/*;
RUN set -x \
   && curl -f -sSLO https://github.com/mozilla/geckodriver/releases/download/${GECKODRIVER_VER}/geckodriver-${GECKODRIVER_VER}-linux64.tar.gz \
   && tar zxf geckodriver-*.tar.gz \
   && mv geckodriver /usr/bin/ && rm geckodriver-*.tar.gz

ADD . /opt/sfm-test/
WORKDIR /opt/sfm-test
RUN pip install --no-cache-dir -r requirements/smoke_requirements.txt
CMD appdeps.py --wait-secs 180 --port-wait mq:5672 --port-wait ui:8080 \
    && python -m unittest discover
