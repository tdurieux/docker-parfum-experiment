FROM python:3

RUN apt-get update -y
RUN apt-get install --no-install-recommends -y vim \
                       dnsutils \
                       apt-transport-https \
                       ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

RUN apt-get update -y
RUN apt-get install --no-install-recommends -y kubectl && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir kubernetes \
                httpie \
                ipython

CMD bash