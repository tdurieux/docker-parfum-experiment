FROM python:3.8.6

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y sox && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gcc-multilib g++-multilib && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsndfile1 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y zip unzip && rm -rf /var/lib/apt/lists/*;
RUN mkdir /opt/ekstep_data_pipelines/
WORKDIR /opt/ekstep_data_pipelines/


COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY ekstep_data_pipelines /opt/ekstep_data_pipelines/ekstep_data_pipelines
COPY invocation_script.py /opt/ekstep_data_pipelines

COPY lib/wada_snr.tar.gz .
RUN tar -xzvf wada_snr.tar.gz && rm wada_snr.tar.gz

RUN mkdir -p /opt/ekstep_data_pipelines/ekstep_data_pipelines/binaries/
RUN mv WadaSNR /opt/ekstep_data_pipelines/ekstep_data_pipelines/binaries/
RUN ls /opt/ekstep_data_pipelines/ekstep_data_pipelines/binaries/WadaSNR/
RUN rm wada_snr.tar.gz
