FROM python:3.6.5
ADD . /Discord-Selfbot

RUN cd Discord-Selfbot && \
    pip install --no-cache-dir -r requirements.txt

CMD ["/Discord-Selfbot/run_linuxmac.sh"]
