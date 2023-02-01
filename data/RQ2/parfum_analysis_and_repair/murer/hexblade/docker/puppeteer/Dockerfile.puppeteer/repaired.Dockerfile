FROM hexblade/hexblade-basechrome:dev

RUN sudo apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN sudo pip3 install --no-cache-dir notebook

COPY src/pack/util/node.sh /opt/hexblade/src/pack/util/node.sh
RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/node.sh install

ENV PATH "$HOME/bin:$PATH"
RUN npm config set prefix "$HOME" && \
    npm install -g ijavascript-await && \
    ijsinstall && \
    sudo find /home/hex -readable -exec chmod og+r "{}" \; && \
    sudo find /home/hex -writable -exec chmod og+w "{}" \; && \
    sudo find /home/hex -executable -exec chmod og+x "{}" \; && npm cache clean --force;


ENV PUPPETEER_EXECUTABLE_PATH /usr/bin/google-chrome
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
COPY --chown=hex:hex docker/puppeteer/workspace /workspace
WORKDIR /workspace
RUN sudo chown hex:hex /workspace && \
    npm install && \
    sudo find /workspace -readable -exec chmod og+r "{}" \; && \
    sudo find /workspace -writable -exec chmod og+w "{}" \; && \
    sudo find /workspace -executable -exec chmod og+x "{}" \; && npm cache clean --force;
CMD jupyter-notebook --ip=0.0.0.0
COPY . /opt/hexblade
