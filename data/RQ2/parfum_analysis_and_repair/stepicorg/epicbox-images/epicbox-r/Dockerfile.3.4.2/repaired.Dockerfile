FROM stepik/epicbox-r:3.4.2

RUN Rscript -e 'install.packages(c("car"))'