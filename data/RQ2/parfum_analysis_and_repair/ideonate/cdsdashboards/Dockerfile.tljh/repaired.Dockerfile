ARG BASE_IMAGE=ideonate/tljh-dev:latest
FROM $BASE_IMAGE

RUN apt-get update && apt-get --assume-yes -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

# Might have put this in /tmp, but it could be useful to have around later for debugging
RUN mkdir /opt/cdsdashboard_current

ADD . /opt/cdsdashboard_current/

COPY ./e2e/setup-helper/startup-script.sh /usr/local/bin/startup-script.sh

RUN cd /opt/cdsdashboard_current \
        && /opt/tljh/hub/bin/python3 setup.py sdist \
        && /opt/tljh/hub/bin/python3 -m pip install ./`ls dist/cdsdashboards-*.tar.gz` \
        && /opt/tljh/user/bin/python3 -m pip install ./`ls dist/cdsdashboards-*.tar.gz`[user]

RUN /opt/tljh/user/bin/python3 -m pip install voila streamlit dash bokeh panel

CMD ["/usr/local/bin/startup-script.sh", "/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]

LABEL com.containds.e2etest="image"
