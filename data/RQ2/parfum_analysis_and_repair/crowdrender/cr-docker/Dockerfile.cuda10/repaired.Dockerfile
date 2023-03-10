FROM zocker160/blender:2.83-LTS-cuda10

MAINTAINER zocker-160

ENV CR_VERSION latest
ENV persistent "false"
ENV local "false"
ENV usegpu "true"

RUN apt-get update && apt-get install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;

WORKDIR /CR
COPY download_cr.sh .
COPY start_cr_server.sh .
COPY install_addon.py .
COPY activate_gpu.py .

RUN chmod +x ./download_cr.sh && chmod +x ./start_cr_server.sh
RUN chmod -R 777 /CR

ENTRYPOINT ./start_cr_server.sh
