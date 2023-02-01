FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y wget perl-modules && rm -rf /var/lib/apt/lists/*;

RUN wget https://ems3.comet.ucar.edu/strc/uems/uems_install.pl.gz && gunzip uems_install.pl.gz && chmod +x uems_install.pl

RUN mkdir /usr1
RUN ./uems_install.pl --install --allyes

RUN rm ./uems_install.pl

RUN sed -i '/SOCKETS=/c\SOCKETS=$(lscpu | grep "Socket(s)" | cut -d":" -f2 | tr -d "[:space:]"); export SOCKETS' /usr1/uems/etc/EMS.profile
RUN sed -i '/CORES=/c\CORES=$(lscpu | grep "Core(s) per socket" | cut -d":" -f2 | tr -d "[:space:]"); export CORES' /usr1/uems/etc/EMS.profile
RUN echo '. /usr1/uems/etc/EMS.profile' >> ~/.bashrc

RUN apt-get install -y --no-install-recommends xorg iproute2 && rm -rf /var/lib/apt/lists/*;
