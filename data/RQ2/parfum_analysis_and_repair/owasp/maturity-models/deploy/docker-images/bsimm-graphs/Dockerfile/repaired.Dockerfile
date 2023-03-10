FROM    node

RUN 	git clone https://github.com/DinisCruz/Maturity-Models.git
WORKDIR Maturity-Models
RUN     sed -i 's/git@github.com:/https:\/\/<user>:<token>@github.com\//' .gitmodules
RUN     git submodule init
RUN     git submodule update
RUN     git pull origin master
RUN npm install && npm cache clean --force;

RUN npm install -g bower; npm cache clean --force; bower --allow-root install
RUN npm install -g gulp; npm cache clean --force;
RUN     cd ui; gulp

RUN     mkdir logs              # node app was failing to create this folder

CMD     npm start

