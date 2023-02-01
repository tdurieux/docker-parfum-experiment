FROM python:3.7

RUN mkdir /termin

COPY requirements.txt /termin

WORKDIR /termin
RUN pip install --no-cache-dir -r requirements.txt

ADD . /termin

CMD python /termin/tg_bot.py