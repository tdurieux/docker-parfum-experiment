FROM noirolabs/ubibase-aci:latest
COPY dist-static/aci-containers-host-agent dist-static/opflex-agent-cni docker/launch-hostagent.sh docker/enable-hostacc.sh docker/enable-droplog.sh /usr/local/bin/
ENV TENANT=kube
ENV NODE_EPG='kubernetes|kube-nodes'
CMD ["/usr/local/bin/launch-hostagent.sh"]