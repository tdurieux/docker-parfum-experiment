FROM ubuntu:14.04.4

ADD prepare_vm.sh /prepare_vm.sh

RUN /prepare_vm.sh && rm /prepare_vm.sh
