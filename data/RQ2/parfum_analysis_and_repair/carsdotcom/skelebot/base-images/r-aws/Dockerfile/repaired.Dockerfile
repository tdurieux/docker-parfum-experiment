FROM skelebot/r-base
MAINTAINER Sean Shookman <sshookman@cars.com>

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get --no-install-recommends install -y -q build-essential krb5-user libsasl2-dev libsasl2-modules-gssapi-mit && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update
RUN apt-get install --no-install-recommends -y openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libmariadb-dev-compat libmariadb-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;

RUN curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

RUN R CMD javareconf
RUN ["Rscript", "-e", "install.packages('rJava',repo='https://cloud.r-project.org');library(rJava)"]
RUN ["Rscript", "-e", "install.packages('RJDBC',repo='https://cloud.r-project.org');library(RJDBC)"]

RUN ["python3", "-m", "pip", "install", "--no-use-pep51", "pyarrow"]
RUN ["pip3", "install", "s3fs==0.2.1"]
RUN ["pip3", "install", "pandas"]
RUN ["pip3", "install", "pyyaml==5.1.2"]
