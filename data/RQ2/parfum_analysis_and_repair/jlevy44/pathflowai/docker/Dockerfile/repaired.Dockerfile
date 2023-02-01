FROM continuumio/anaconda3

USER root

RUN apt-get -y update && apt install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

COPY spec-list.pathflow.txt .

RUN conda create --name default --file spec-list.pathflow.txt && \
  rm spec-list.pathflow.txt

RUN apt-get install --no-install-recommends -y openslide-tools && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt && \
    rm requirements.txt

RUN pip install --no-cache-dir git+https://github.com/jlevy44/PathFlowAI.git

RUN install_apex

#ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
