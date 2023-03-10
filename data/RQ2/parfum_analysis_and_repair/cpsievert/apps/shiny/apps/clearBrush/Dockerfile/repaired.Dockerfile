FROM cpsievert/apps:shiny
MAINTAINER Carson Sievert "cpsievert1@gmail.com"

RUN R -e "install.packages(c('shinyjs', 'ggplot2'))"

# copy the app to the image
COPY ./ ./

CMD R -e 'shiny::runApp()'