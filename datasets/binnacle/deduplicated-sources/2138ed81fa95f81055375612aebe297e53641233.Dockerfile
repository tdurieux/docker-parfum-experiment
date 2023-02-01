FROM ubuntu:16.04  
COPY *.sh /tmp/  
RUN /tmp/install_runtime.sh \  
&& rm -rf /var/lib/apt/lists \  
&& rm -rf ~/.cache/pip  
  
WORKDIR /cita  
ENV PATH $PATH:/cita/bin  
CMD /bin/bash  

