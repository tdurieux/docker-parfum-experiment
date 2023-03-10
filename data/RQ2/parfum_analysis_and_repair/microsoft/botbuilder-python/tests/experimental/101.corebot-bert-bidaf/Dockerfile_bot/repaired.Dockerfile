FROM    tiangolo/uwsgi-nginx-flask:python3.6

# Setup for nginx
RUN mkdir -p /home/LogFiles \
     && apt update \
     && apt install -y --no-install-recommends vim && rm -rf /var/lib/apt/lists/*;

EXPOSE 3978

COPY /model /model

# Pytorch very large.  Install from wheel.
RUN wget https://files.pythonhosted.org/packages/69/60/f685fb2cfb3088736bafbc9bdbb455327bdc8906b606da9c9a81bae1c81e/torch-1.1.0-cp36-cp36m-manylinux1_x86_64.whl
RUN pip3 install --no-cache-dir torch-1.1.0-cp36-cp36m-manylinux1_x86_64.whl

RUN pip3 install --no-cache-dir -e /model/


COPY ./bot /bot

RUN pip3 install --no-cache-dir -r /bot/requirements.txt

ENV FLASK_APP=/bot/main.py
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV PATH ${PATH}:/home/site/wwwroot

WORKDIR bot
# Initialize models


# For Debugging, uncomment the following:
#ENTRYPOINT ["python3.6", "-c", "import time ; time.sleep(500000)"]
ENTRYPOINT [ "flask" ]
CMD [ "run", "--port", "3978", "--host", "0.0.0.0" ]
