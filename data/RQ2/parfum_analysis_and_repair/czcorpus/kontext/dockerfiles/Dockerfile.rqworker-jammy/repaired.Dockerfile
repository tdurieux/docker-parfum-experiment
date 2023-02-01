FROM czcorpus/kontext-manatee:2.208-jammy

RUN mkdir /var/log/rq
WORKDIR /opt/kontext
COPY . .
RUN pip3 install --no-cache-dir --upgrade pip && pip3 install --no-cache-dir -r requirements.txt
RUN python3 scripts/install/steps.py SetupKontext

CMD [ "python3",  "worker/rqworker.py" ]