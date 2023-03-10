FROM cpsievert/apps:shiny
MAINTAINER Carson Sievert "cpsievert1@gmail.com"

RUN R -e "install.packages('ggplot2')"

# copy the app to the image
COPY ./ ./

# run the app
CMD R -e 'shiny::runApp()'