FROM berkeleyscheduler/base
MAINTAINER Dibyo Majumdar <dibyo.majumdar@gmail.com>


COPY requirements.txt .
RUN pip3 install --no-cache-dir --upgrade pip \
  && pip3 install --no-cache-dir -r requirements.txt

COPY run.sh .

EXPOSE 8085

ENTRYPOINT ["./berkeley-scheduler/server/user-accounts/run.sh"]
