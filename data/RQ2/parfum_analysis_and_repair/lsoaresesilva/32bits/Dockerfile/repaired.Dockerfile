FROM fedora
RUN sudo dnf -y install nodejs npm git python3 python3-pip nginx
RUN sudo alternatives --install /usr/bin/python python /usr/bin/python3.7 1
RUN sudo npm install -g @angular/cli && npm cache clean --force;
RUN pip3 install --no-cache-dir --user Django==2.2.4
RUN pip3 install --no-cache-dir --user djangorestframework
RUN pip3 install --no-cache-dir --user django-cors-headers
RUN pip3 install --no-cache-dir --user pexpect
RUN pip3 install --no-cache-dir --user firebase-admin
RUN pip3 install --no-cache-dir uwsgi
RUN mkdir ~/projetos
RUN git clone https://github.com/lsoaresesilva/32bits.git ~/projetos/32bits
RUN git clone https://github.com/lsoaresesilva/32bits-backend.git ~/projetos/32bits-backend
WORKDIR /root/projetos/32bits
RUN npm install && npm cache clean --force;
RUN cd src/app/model/firestore && git submodule update --init --recursive
EXPOSE 80
RUN sudo systemctl start nginx
WORKDIR /root/projetos/32bits-backend
RUN python manage.py collectstatic
#RUN uwsgi --plugins http,python3 --socket :8001 --module lets.wsgi:application
#RUN ng serve
