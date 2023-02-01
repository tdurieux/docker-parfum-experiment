FROM python:3.6-stretch as multi-stage-build-intermediate

# install git
RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# add credentials on build
ARG SSH_PRIVATE_KEY
RUN mkdir /root/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa

# make sure your domain is accepted
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts

COPY requirements.txt /

WORKDIR /pip-packages/
RUN pip install --no-cache-dir --upgrade pip
RUN pip download -r /requirements.txt

FROM python:3.6-stretch as multi-stage-build-final

WORKDIR /python/scikit-deploy

COPY . .

COPY --from=multi-stage-build-intermediate /pip-packages/ /scikit-deploy/pip-packages/

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir gunicorn
RUN pip install --no-cache-dir --no-index --find-links=/scikit-deploy/pip-packages/ /scikit-deploy/pip-packages/*
RUN python3 validate.py

EXPOSE 5000

CMD ["gunicorn", "-b", "0.0.0.0:8000", "--workers=2", "main:app"]