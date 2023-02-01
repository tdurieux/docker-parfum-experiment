FROM python

ADD requirements.txt /bot/
WORKDIR /bot
RUN pip install -r ./requirements.txt

ADD bot /bot

CMD ["python", "./main.py"]

EXPOSE 8080
