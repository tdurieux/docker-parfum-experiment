FROM ocaml/opam
# ...just build the ocamlpaxos binaries

#RUN make op-deps

#FROM base as ocaml_builder
#ENV OPAMYES=1
#RUN apt update && apt install liblapacke-dev libopenblas-dev zlib1g-dev -y
#ADD systems/ocaml-paxos/src/ocamlpaxos.opam systems/ocaml-paxos/src/ocamlpaxos.opam
#RUN opam install --deps-only systems/ocaml-paxos/src -y
#ADD src/ocaml_client src/ocaml_client
#ADD src/utils/message.proto src/utils/message.proto
#RUN cd src/ocaml_client && make install

##- ocaml-paxos ------
#
#FROM ocaml_builder as ocaml_paxos_builder
#ADD systems/ocaml-paxos/Makefile systems/ocaml-paxos/Makefile
#ADD systems/ocaml-paxos/src systems/ocaml-paxos/src
#ADD systems/ocaml-paxos/clients systems/ocaml-paxos/clients
#RUN cd systems/ocaml-paxos && make system
##Invalidate cache if client library has been updated
##COPY src/go/src/github.com/Cjen1/rc_go rc_go
##COPY src/go/src/github.com/Cjen1/rc_go go-deps
##COPY systems/ocaml-paxos/go go-deps
#RUN cd systems/ocaml-paxos && make client