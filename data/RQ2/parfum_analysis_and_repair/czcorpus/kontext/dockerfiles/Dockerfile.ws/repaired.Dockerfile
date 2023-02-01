FROM czcorpus/kontext-manatee:latest

RUN pip3 install --no-cache-dir --upgrade pip && pip3 install --no-cache-dir aiohttp

WORKDIR /opt/kontext
COPY . .
RUN pip3 install --no-cache-dir -r requirements.txt
RUN python3 scripts/install/steps.py SetupKontext

CMD [ "python3", "public/ws_app.py", "--host", "0.0.0.0" ]
