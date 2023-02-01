FROM debian:sid

ENV LANG C.UTF-8
ENV USER root
ENV HOME /cloudfail
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -yq python3-pip && rm -rf /var/lib/apt/lists/*;

COPY . $HOME

WORKDIR $HOME

RUN pip3 install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python3", "cloudfail.py"]
