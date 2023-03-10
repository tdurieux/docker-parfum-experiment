FROM bcgovimages/von-image:py36-1.11-1

ARG hospital_name
ARG data_file

RUN echo "Hello $hospital_name"

ENV ENABLE_PTVSD 0
ENV HOSPITAL_NAME $hospital_name

# Add and install Indy Agent code
ADD requirements*.txt ./

RUN pip3 install --no-cache-dir -r requirements.txt -r requirements.dev.txt -r requirements.hospitals.txt


RUN mkdir demo
RUN mkdir model

ADD aries_cloudagent ./aries_cloudagent
ADD bin ./bin
ADD README.md ./
ADD scripts ./scripts
ADD setup.py ./
ADD data/"$data_file".csv ./data/data.csv
ADD data/hospital_learn.py ./data/hospital_learn.py
ADD demo/sovrin-genesis.txt ./sovrin-genesis.txt


RUN pip3 install --no-cache-dir -e .

# Add and install demo code
ADD demo/requirements.txt ./demo/requirements.txt
RUN pip3 install --no-cache-dir -r demo/requirements.txt

ADD demo ./demo

ENTRYPOINT ["/bin/bash", "-c", "python -m demo.runners.$@", "--"]