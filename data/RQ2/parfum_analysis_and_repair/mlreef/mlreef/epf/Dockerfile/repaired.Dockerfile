FROM tensorflow/tensorflow:2.1.0-gpu-py3
MAINTAINER MLReef

ENV TENSORFLOW_VERSION 2.1.0

########## MLREEF ##########

RUN apt-get update && \
    apt-get install --no-install-recommends -y apt-utils && \
    apt-get install --no-install-recommends --yes git && \
    apt-get install --no-install-recommends -y wget && \
    apt-get install --no-install-recommends -y wget gnupg gnupg2 gnupg1 && \
    wget https://dvc.org/deb/dvc.list -O /etc/apt/sources.list.d/dvc.list && \
    wget -qO - https://dvc.org/deb/iterative.asc | apt-key add - && \
    apt-get update && \
    apt-get install --no-install-recommends -y dvc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

##### ADD files to the image
WORKDIR /
ADD src /epf
ADD src/bin /bin
RUN chmod +x /bin -R


###### Setup Python and vergeml
WORKDIR /app
RUN apt-get update                                                                 
RUN apt-get install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/


RUN echo "------------------------------------------------------------------------" && \
    echo "                       MLREEF EPF: Setting Up"                            && \
    echo "------------------------------------------------------------------------" && \
    apt-get update && \
    apt-get install --no-install-recommends -y libsm6 libfontconfig1 libxrender1 && \
    python --version && rm -rf /var/lib/apt/lists/*;


##### Add container startup script
CMD echo "------------------------------------"                                     && \
    echo "       MLREEF EPF Starting"                                               && \
    echo "------------------------------------"                                     && \
    cd /app 					                                                    && \
    python --version 			                                                	&& \
    ls -la /dev | grep nvidia                                                       && \
    nvidia-smi                                                                     

