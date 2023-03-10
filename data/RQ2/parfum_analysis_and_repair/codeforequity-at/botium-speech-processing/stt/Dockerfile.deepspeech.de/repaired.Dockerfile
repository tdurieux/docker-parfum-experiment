FROM python:3.5

# From https://github.com/AASHISHAG/deepspeech-german
RUN mkdir /models
RUN wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1THSQwbI_ENjZ7m7GadjFQxyhJm7V29sa' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1THSQwbI_ENjZ7m7GadjFQxyhJm7V29sa" -O /models/lm.binary && rm -rf /tmp/cookies.txt
RUN wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1PRnUaWCSLH92YOW0p3v73LCY4vnttwrg' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1PRnUaWCSLH92YOW0p3v73LCY4vnttwrg" -O /models/alphabet.txt && rm -rf /tmp/cookies.txt
RUN wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=10SHJQvEkuhb3fzv4sfC5vzKw5vw-Lt61' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=10SHJQvEkuhb3fzv4sfC5vzKw5vw-Lt61" -O /models/model_tuda+voxforge+mozilla.pb && rm -rf /tmp/cookies.txt
RUN wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1QTGl1rQkh5XnLmWM6i70j5BV1MrECn1p' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1QTGl1rQkh5XnLmWM6i70j5BV1MrECn1p" -O /models/trie && rm -rf /tmp/cookies.txt

COPY ./models/config_de.json /models/config.json
ENV config /models/config.json

RUN pip3 install --no-cache-dir "deepspeech==0.5.1"
RUN pip3 install --no-cache-dir "deepspeech-server==1.1.0"
RUN pip3 uninstall -y cyclotron && pip3 install --no-cache-dir "cyclotron==0.6.1"
RUN pip3 uninstall -y cyclotron-aio && pip3 install --no-cache-dir "cyclotron-aio==0.7.0"
RUN pip3 uninstall -y cyclotron-std && pip3 install --no-cache-dir "cyclotron-std==0.5.0"
RUN pip3 uninstall -y Rx && pip3 install --no-cache-dir "Rx==1.6.1"

CMD ["sh", "-c", "/usr/local/bin/deepspeech-server --config ${config}"]