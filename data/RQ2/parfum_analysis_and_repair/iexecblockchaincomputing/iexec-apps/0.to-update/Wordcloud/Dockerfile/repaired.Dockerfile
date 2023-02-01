FROM r-base
RUN apt-get update
RUN apt-get install --no-install-recommends -y libapparmor-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libpoppler-cpp-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libpoppler-glib-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libxml2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgeos-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libwebp-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libmagic-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;


RUN R -e 'install.packages("tm", dependencies = TRUE)'
RUN R -e 'install.packages("pdftools", dependencies = TRUE)'
RUN R -e 'install.packages("wordcloud", dependencies = TRUE)'
RUN R -e 'install.packages("RColorBrewer", dependencies = TRUE)'
RUN R -e 'install.packages("RCurl", dependencies = TRUE)'
RUN R -e 'install.packages("drat", dependencies = TRUE)'
RUN R -e 'drat::addRepo("RInstitute")' -e 'install.packages("dqmagic", dependencies = TRUE)'





