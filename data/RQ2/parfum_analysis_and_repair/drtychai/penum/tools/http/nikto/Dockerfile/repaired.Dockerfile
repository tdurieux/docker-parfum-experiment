FROM ubuntu:18.04
RUN apt update --fix-missing \
    && apt -y --no-install-recommends install git xinetd parallel nikto \
    && apt clean && rm -rf /var/lib/apt/lists/*;

ADD config/run_tool.sh /etc/run_tool.sh
ADD config/main.xinetd /etc/xinetd.d/main
ADD config/run_xinetd.sh /etc/run_xinetd.sh

RUN chmod +x /etc/run_xinetd.sh
RUN chmod +x /etc/run_tool.sh

RUN service xinetd restart
