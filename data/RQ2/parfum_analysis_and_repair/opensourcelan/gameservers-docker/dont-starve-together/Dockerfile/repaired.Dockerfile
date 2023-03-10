FROM steamcmd

RUN mkdir /steam/dontstarve
RUN ./steamcmd.sh +login anonymous +force_install_dir /steam/dontstarve +app_update 343050 validate +quit
#RUN ./steamcmd.sh +login anonymous +force_install_dir /steam/dontstarve +app_update 343050 validate -beta anewreignbeta +quit
USER root
RUN apt-get update && apt-get install --no-install-recommends -y xvfb && rm -rf /var/lib/apt/lists/*;
USER steam
WORKDIR /steam/dontstarve/

CMD ["/steam/dontstarve/start-dontstarve.sh"]