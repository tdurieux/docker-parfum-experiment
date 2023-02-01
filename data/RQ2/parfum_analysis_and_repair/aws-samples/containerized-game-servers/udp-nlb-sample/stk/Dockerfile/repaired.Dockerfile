FROM public.ecr.aws/p9d8y1e7/supertuxkart:arm9
RUN apt install --no-install-recommends -y telnet && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pyenet
COPY server_config.xml /stk-code/server_config.xml
COPY start-server.sh /stk-code/start-server.sh
COPY udp-health-probe.py /udp-health-probe.py
