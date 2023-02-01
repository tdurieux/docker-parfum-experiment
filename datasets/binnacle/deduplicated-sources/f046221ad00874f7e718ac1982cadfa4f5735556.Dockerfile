FROM alpine:latest
RUN apk update && apk upgrade && apk add bash && apk add python3 && pip3 install requests && pip3 install PTable
RUN apk add git && git clone --recursive https://github.com/kubernetes-client/python.git && cd python/ && python3 setup.py install 
RUN echo "alias kubiscan='python3 /KubiScan/KubiScan.py'" > /root/.bash_aliases && echo "alias kubiscan='python3 /KubiScan/KubiScan.py'" > /root/.bashrc
RUN . /root/.bash_aliases
COPY . /KubiScan
ENTRYPOINT bash
