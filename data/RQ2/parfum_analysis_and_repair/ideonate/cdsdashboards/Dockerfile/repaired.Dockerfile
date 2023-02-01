ARG BASE_IMAGE=jupyterhub/jupyterhub:1.5
FROM $BASE_IMAGE

RUN apt-get update && apt-get --assume-yes -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install setuptools notebook dockerspawner

RUN mkdir /tmp/cdsdashboard_current

ADD . /tmp/cdsdashboard_current/

COPY ./e2e/setup-helper/startup-script.sh /usr/local/bin/startup-script.sh

RUN cd /tmp/cdsdashboard_current \
        && python3 setup.py sdist \
        && python3 -m pip install ./`ls dist/cdsdashboards-*.tar.gz`[user] \
        && cd .. && rm -rf ./cdsdashboard_current

RUN pip install --no-cache-dir voila streamlit dash bokeh panel

ENTRYPOINT ["/usr/local/bin/startup-script.sh"]

CMD ["jupyterhub"]

LABEL com.containds.e2etest="image"
