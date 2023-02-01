FROM ubuntu:18.04

# update/upgrade base system
RUN apt-get update && apt-get -yq upgrade

# install python, pip
RUN apt-get install --no-install-recommends -yq python python-pip && pip install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

# COPY mission2plan.py file to docker image
RUN mkdir /opt/warehousecontroller
WORKDIR /opt/warehousecontroller
COPY mission2plan.py .
COPY requirements.txt .
COPY kb.json .
COPY mission.json .
COPY whdomain-2.pddl .

# INSTALL requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# expose port
EXPOSE 5000

# start flask application
CMD python mission2plan.py
