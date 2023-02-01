FROM postgres:latest

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt install -y --no-install-recommends keyutils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app
RUN mkdir -p /usr/src/app/tb_files && rm -rf /usr/src/app/tb_files

COPY db_queries.sql .
COPY db_refresh.sql .
COPY db-refresher.sh .

RUN mkdir -p /usr/src/app/utils && rm -rf /usr/src/app/utils
RUN wget -O azcopy_v10.tar.gz https://aka.ms/downloadazcopy-v10-linux && tar -xf azcopy_v10.tar.gz --strip-components=1 && rm azcopy_v10.tar.gz

RUN cp azcopy /usr/src/app/utils/

ENTRYPOINT [ "sh","db-refresher.sh"]
