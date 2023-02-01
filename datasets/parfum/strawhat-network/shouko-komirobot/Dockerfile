FROM linuxserver/calibre:latest

WORKDIR /Processed_By

RUN apt-get -y update \
  && apt -y install python3-pip \
  && pip3 install hachoir \
  && pip3 install pyrogram \
  && pip3 install tgcrypto \
  && pip3 install python-dotenv 
  
COPY . .

CMD ["bash","start.sh"]