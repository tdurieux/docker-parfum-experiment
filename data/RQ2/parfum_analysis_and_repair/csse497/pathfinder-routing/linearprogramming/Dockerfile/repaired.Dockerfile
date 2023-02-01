FROM ubuntu:14.04
MAINTAINER Adam Michael <adam@ajmichael.net>

# Julia
RUN apt-get update && apt-get install --no-install-recommends -y wget python-software-properties software-properties-common libglfw2 libglfw-dev && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:staticfloat/juliareleases && apt-get update
RUN apt-get install --no-install-recommends -y julia && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential cmake xorg-dev libglu1-mesa-dev git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgmp-dev && rm -rf /var/lib/apt/lists/*;
RUN julia -e "Pkg.resolve()"

# Dependencies
ADD REQUIRE /.julia/v0.4/REQUIRE
RUN julia -e "Pkg.resolve()"
RUN julia -e 'Pkg.add("Clp")'
RUN julia -e 'Pkg.add("HttpServer")'
RUN julia -e 'Pkg.add("JuMP")'
RUN julia -e 'Pkg.add("JSON")'
RUN julia -e 'Pkg.add("Logging")'


# Server
ADD src /
RUN chmod +x /server.sh
CMD ["/server.sh"]
