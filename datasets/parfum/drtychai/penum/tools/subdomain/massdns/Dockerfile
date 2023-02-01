FROM ubuntu:18.04
ENV TOOL massdns

RUN apt update --fix-missing \
    && apt install -y libldns-dev git build-essential python

RUN git clone https://github.com/blechschmidt/massdns.git /${TOOL} \
    && make -C /${TOOL}

FROM ubuntu:18.04
ENV TOOL massdns
RUN apt update --fix-missing \
    && apt -y install xinetd jq parallel

COPY --from=0 /massdns/bin/${TOOL} /bin/${TOOL}

ADD ./wordlists/ns.txt /resolvers.txt
ADD ./wordlists/subdomains-top1million-110000.txt /wl.txt

ADD config/run_tool.sh /etc/run_tool.sh
ADD config/main.xinetd /etc/xinetd.d/main
ADD config/run_xinetd.sh /etc/run_xinetd.sh

RUN chmod +x /etc/run_xinetd.sh
RUN chmod +x /etc/run_tool.sh

RUN mkdir -p /massdns-output && chmod -R 700 /massdns-output

RUN service xinetd restart
