FROM querqy/smui:3.13.9

COPY conf/smui2solrcloud.sh /smui/conf/smui2solrcloud.sh
COPY conf/*.py /smui/conf/
COPY conf/predefined_tags.json /smui/conf/predefined_tags.json

USER root
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
USER smui
RUN python3 -m pip install requests
