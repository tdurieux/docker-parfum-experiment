FROM phusion/baseimage:latest
RUN apt update -y && apt install --no-install-recommends -y bash && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /root/ezsh-code
COPY . /root/ezsh-code
WORKDIR /root/ezsh-code
RUN chmod +x requirements
RUN bash requirements
RUN chmod +x ezsh
RUN ln -s /lib/x86_64-linux-gnu/libreadline.so.6 /lib/x86_64-linux-gnu/libreadline.so.7
