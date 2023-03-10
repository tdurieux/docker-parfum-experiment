FROM    node

RUN 	git clone https://github.com/DinisCruz/BSIMM-Graphs.git
WORKDIR BSIMM-Graphs
RUN     sed -i 's/git@github.com:/https:\/\/<user>:<token>@github.com\//' .gitmodules
RUN     git submodule init
RUN npm install bower -g ; npm cache clean --force; bower --allow-root install
RUN npm install && npm cache clean --force;

CMD     npm start