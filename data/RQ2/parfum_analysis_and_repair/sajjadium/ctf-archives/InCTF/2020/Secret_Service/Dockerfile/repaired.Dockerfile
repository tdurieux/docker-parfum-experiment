FROM ubuntu:20.04

ENV TZ=Asia/Kolkata

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
     apt-get -y upgrade && \
     apt-get install --no-install-recommends -y libseccomp-dev && \
     apt-get install --no-install-recommends -y xinetd && \
     apt-get install --no-install-recommends -y gdb && \
     apt-get install --no-install-recommends -y git && \
     apt-get install --no-install-recommends -y gcc python2.7-dev && \
     apt-get install --no-install-recommends -y software-properties-common && \
     apt install --no-install-recommends -y python2 && \
     apt-get update && \
     apt install --no-install-recommends -y curl && \
     curl -f https://bootstrap.pypa.io/get-pip.py --output get-pip.py && \
     python2 get-pip.py && \
     pip install --no-cache-dir --upgrade setuptools && rm -rf /var/lib/apt/lists/*;

RUN  python2.7 -m pip install --upgrade pwntools

RUN useradd -m ctf

WORKDIR /home/ctf

ADD chall /home/ctf
ADD libseccomp.so.2 /home/ctf
ADD exp.py /home/ctf
ADD libc.so.6 /home/ctf
RUN cp libseccomp.so.2 /usr/lib/x86_64-linux-gnu/
RUN git clone https://github.com/longld/peda.git ~/peda
RUN echo "source ~/peda/peda.py" >> ~/.gdbinit
RUN apt install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y tmux && rm -rf /var/lib/apt/lists/*;
