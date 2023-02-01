FROM crystallang/crystal:0.35.1 as builder

RUN apt-get update && apt-get upgrade -y
RUN apt install --no-install-recommends python -y && rm -rf /var/lib/apt/lists/*;

ADD ./ /
RUN make nodejs

RUN /lib/x86_64-linux-gnu/libc.so.6
RUN echo "completed"
