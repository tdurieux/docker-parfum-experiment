FROM ubuntu:latest

MAINTAINER crits

RUN apt-get -qq update
# git command
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
# pip command
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
# lsb_release command
RUN apt-get install --no-install-recommends -y lsb-release && rm -rf /var/lib/apt/lists/*;
# sudo command
RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
# add-apt-repository command
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

# Clone the repo
RUN git clone --depth 1 https://github.com/crits/crits.git

WORKDIR crits
# Install the dependencies
RUN TERM=xterm sh ./script/bootstrap < docker_inputs

# Create a new admin. Username: "admin" , Password: "pass1PASS123!"
RUN sh contrib/mongo/mongod_start.sh && python manage.py users -R UberAdmin -u admin -p "pass1PASS123!" -s -i -a -e admin@crits.crits -f "first" -l "last" -o "no-org"

EXPOSE 8080

CMD sh contrib/mongo/mongod_start.sh && python manage.py runserver 0.0.0.0:8080
