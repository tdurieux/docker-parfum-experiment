FROM r-base:3.6.3
MAINTAINER Sean Shookman <sshookman@cars.com>

RUN apt-get update
RUN apt-get install --no-install-recommends -y jupyter && rm -rf /var/lib/apt/lists/*;

RUN ["Rscript", "-e", "install.packages('IRkernel', repo='https://cloud.r-project.org'); IRkernel::installspec()"]

RUN apt-get install --no-install-recommends -y libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libxml2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gfortran && rm -rf /var/lib/apt/lists/*;
RUN ["Rscript", "-e", "install.packages('glue', repo='https://cloud.r-project.org'); library(glue)"]
RUN ["Rscript", "-e", "install.packages('devtools', repo='https://cloud.r-project.org'); library(devtools)"]
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip --no-cache-dir install jupyterlab
