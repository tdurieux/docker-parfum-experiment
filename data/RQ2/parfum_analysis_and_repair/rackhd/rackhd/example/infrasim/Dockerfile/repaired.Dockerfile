#Copyright © 2017 Dell Inc. or its subsidiaries.  All Rights Reserved.

FROM infrasim/infrasim-compute:3.5.1

COPY default.yml /root/.infrasim/.node_map/

COPY start_infrasim.sh .

RUN apt-get install --no-install-recommends -y dos2unix && rm -rf /var/lib/apt/lists/*;
RUN dos2unix start_infrasim.sh

ENTRYPOINT ./start_infrasim.sh
