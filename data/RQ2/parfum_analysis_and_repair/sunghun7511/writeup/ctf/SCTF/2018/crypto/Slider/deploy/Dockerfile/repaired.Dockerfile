FROM ubuntu:16.04

RUN sed -i "s/http:\/\/archive.ubuntu.com/http:\/\/ftp.daumkakao.com/g" /etc/apt/sources.list
RUN apt update && apt -y upgrade

RUN apt install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt install --no-install-recommends -y socat && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pycrypto

ENV PROB Slider
RUN useradd -m $PROB
WORKDIR /home/$PROB

COPY ./start.sh /start.sh
ADD ./src/* /home/$PROB/
RUN chmod +x /start.sh

RUN chown -R $PROB:$PROB /home/$PROB
USER $PROB

CMD ["/start.sh"]
EXPOSE 6884
