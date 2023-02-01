FROM golang:1.17

ADD reckon/systems/etcd/Makefile /reckon/systems/etcd/Makefile
RUN cd /reckon/systems/etcd && make docker-build-deps
RUN cd /reckon/systems/etcd && make system

ADD reckon/goclient /reckon/goclient
ADD reckon/systems/etcd/clients /reckon/systems/etcd/clients
RUN cd /reckon/systems/etcd && make client