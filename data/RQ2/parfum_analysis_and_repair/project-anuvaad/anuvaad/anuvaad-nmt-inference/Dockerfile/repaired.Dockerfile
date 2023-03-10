FROM anuvaadio/nmt:4
#FROM nvidia/cuda:10.2-base
CMD nvidia-smi
RUN apt-get update && apt-get install --no-install-recommends -y locales locales-all && rm -rf /var/lib/apt/lists/*; #RUN apt-get -y install python3
#RUN apt-get -y install python3-pip

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
COPY / /app
WORKDIR /app
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r src/requirements.txt
CMD ["python3", "/app/src/app.py"]
