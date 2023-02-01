FROM node:16
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update && apt-get install --no-install-recommends python3 python3-pip python3-dev -y && rm -rf /var/lib/apt/lists/*; ADD get-poetry.py /home/
ADD *.toml /home/

WORKDIR /home/


RUN pip3 install --no-cache-dir tenacity httpx pydantic requests
RUN python3 get-poetry.py
RUN npm install -g pm2 && npm cache clean --force;
RUN ln -sf /usr/bin/python3 /usr/bin/python

ADD . /home/
RUN source ~/.poetry/env && poetry install
CMD [ "pm2-docker", "./example3_market_maker.py" ]