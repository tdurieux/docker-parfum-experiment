FROM harbor.infinivision.cn/infinivision/tvm-svc

COPY build/tvm_svc /usr/local/bin
COPY start_tvm_svc.sh /usr/local/bin
COPY kubectl /usr/local/bin
ADD  tvm_model /var/lib/tvm_model
ADD  conf /var/lib/tvm_conf

RUN apt-get update; apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/bin/bash","/usr/local/bin/start_tvm_svc.sh"]
