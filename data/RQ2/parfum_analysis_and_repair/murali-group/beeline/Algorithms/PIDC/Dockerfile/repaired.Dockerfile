FROM julia:1.1.0-stretch

LABEL maintainer="Aditya Pratapa <adyprat@vt.edu>"

USER root

WORKDIR /
COPY installPackages.jl /

# Julia libs we want

RUN julia installPackages.jl

COPY runPIDC.jl /


RUN apt-get update && apt-get install -y --no-install-recommends time && rm -rf /var/lib/apt/lists/*;
