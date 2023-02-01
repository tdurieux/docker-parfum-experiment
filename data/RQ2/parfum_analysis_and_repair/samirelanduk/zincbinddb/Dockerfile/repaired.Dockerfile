FROM ubuntu

RUN mkdir -p /home/app

WORKDIR /home/app

RUN apt update
RUN apt -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cron && rm -rf /var/lib/apt/lists/*;
COPY ./requirements.txt ./requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt


COPY ./build ./build
COPY ./core ./core
COPY ./data ./data
COPY ./manage.py ./manage.py
RUN rm ./core/secrets.py
RUN python3 manage.py migrate

RUN wget https://github.com/weizhongli/cdhit/releases/download/V4.8.1/cd-hit-v4.8.1-2019-0228.tar.gz
RUN tar xvf cd-hit-v4.8.1-2019-0228.tar.gz --gunzip && rm cd-hit-v4.8.1-2019-0228.tar.gz
RUN cd cd-hit-v4.8.1-2019-0228 && make
RUN cd cd-hit-v4.8.1-2019-0228/cd-hit-auxtools && make
RUN mv cd-hit-v4.8.1-2019-0228/* /usr/local/bin/


RUN sed -i s/'DEBUG = True'/'DEBUG = False'/g ./core/settings.py

RUN echo "0 5 * * * cd /home/app && python3 build/build.py >> /var/log/cron.log 2>&1 && python3 build/cluster.py >> /var/log/cron.log 2>&1" > scheduler.txt
RUN crontab scheduler.txt

CMD python3 build/build.py && python3 build/cluster.py && cron -f
