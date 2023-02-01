FROM playwright-focal AS CleanInstallTester
# Add pip
USER root
RUN apt-get update && apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
USER pwuser

RUN pip3 install --no-cache-dir --user robotframework
RUN pip3 install --no-cache-dir --user robotframework-browser
# Hard to update PATH for all shells in a docker image so we run python scripts with manual paths
RUN ~/.local/bin/rfbrowser init

ENV NODE_PATH=/usr/lib/node_modules
ENV PATH="/home/pwuser/.local/bin:${PATH}"
# What were these used for previously
# RUN mv /root/.cache/ /home/pwuser/.cache
# RUN chmod a+rwx -R /home/pwuser/.cache
