FROM hyperledger/fabric-nodeenv:latest

ADD . /opt/chaincode
RUN cd /opt/chaincode; npm install && npm cache clean --force;

WORKDIR /opt/chaincode
ENTRYPOINT ["npm", "start"]
