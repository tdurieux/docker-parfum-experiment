FROM ubuntu:trusty
RUN apt-get update && apt-get -y --no-install-recommends install xvfb stterm scrot xautomation && rm -rf /var/lib/apt/lists/*;
ADD screenme.sh /screenme.sh
CMD /screenme.sh /vrhs/shot.png
