FROM python:2.7-slim

RUN apt-get update && apt-get -y --no-install-recommends install openssh-client squashfs-tools munge && rm -rf /var/lib/apt/lists/*;
RUN echo "   StrictHostKeyChecking no" >> /etc/ssh/ssh_config
RUN mkdir /var/run/munge && chown munge /var/run/munge


WORKDIR /usr/src/app

ADD requirements.txt /usr/src/app/

RUN pip install --no-cache-dir -r requirements.txt

COPY . /usr/src/app

RUN echo "CONFIG_PATH='/config'" >> /usr/src/app/shifter_imagegw/__init__.py

ENTRYPOINT [ "./entrypoint.sh" ]
CMD [ ]

