FROM aistore/aisnode:latest-alpine
WORKDIR $GOPATH/src/github.com/NVIDIA/aistore
CMD ["/bin/bash","-c","PORT=51080 make deploy <<< $'1\n1\n3\nn\nn\nn\n' && tail -f /tmp/ais/0/log/* /tmp/ais/1/log/*"]