FROM bcgovimages/von-image:py36-1.11-1

ENV ENABLE_PTVSD 0

# Add and install Indy Agent code
ADD requirements*.txt ./

RUN pip3 install --no-cache-dir -r requirements.txt -r requirements.dev.txt

ADD aries_cloudagent ./aries_cloudagent
ADD bin ./bin
ADD README.md ./
ADD scripts ./scripts
ADD setup.py ./

RUN pip3 install --no-cache-dir -e .

RUN mkdir demo

# Add and install demo code
ADD demo/requirements.txt ./demo/requirements.txt

RUN pip3 install --no-cache-dir -r demo/requirements.txt

ADD demo/sovrin-genesis.txt ./sovrin-genesis.txt

ADD demo ./demo

ENTRYPOINT ["/bin/bash", "-c", "python -m demo.runners.$@", "--"]