FROM torusresearch/prebuilt

RUN cd $HOME/go/src/github.com/torusresearch && rm -rf ./torus && git clone https://github.com/torusresearch/torus

EXPOSE 443 80 26656 26657
VOLUME ["/.build", "/root/https"]
CMD /root/go/bin/dkgnode -privateKey ${PRIVATEKEY} -ipAddress ${IPADDRESS} -nodeListAddress ${NODELISTADDRESS}