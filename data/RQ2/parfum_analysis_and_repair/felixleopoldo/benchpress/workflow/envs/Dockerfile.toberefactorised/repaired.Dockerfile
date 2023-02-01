FROM continuumio/miniconda3

WORKDIR /myappdir

RUN apt update -y
RUN apt install --no-install-recommends -y python-pydot python-pydot-ng graphviz && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /usr/share/man/man1
RUN apt install --no-install-recommends -y default-jre && rm -rf /var/lib/apt/lists/*;
RUN conda update -n base -c defaults conda
RUN conda install -c conda-forge r-base=3.6.3 r-essentials
RUN conda install jupyterlab
RUN conda install pandas
RUN R -e "if (!requireNamespace(\"BiocManager\", quietly = TRUE)) {install.packages(\"BiocManager\", repo=\"http://cran.rstudio.com/\")}" --no-save
RUN R -e "BiocManager::install()"  --no-save
RUN R -e "BiocManager::install(c(\"gRbase\", \"RBGL\", \"Rgraphviz\", \"gRain\"))" --no-save

# python-pydot-ng isn't in the 14.04 repos
# This is also needed
RUN R -e "install.packages(\"IRkernel\", repos=\"https://cran.rstudio.com\")" --no-save
RUN R -e "IRkernel::installspec()" --no-save  # to register the kernel in the current R installation
RUN R -e "install.packages(\"ggplot2\", repos=\"https://cran.rstudio.com\")" --no-save
RUN R -e "install.packages(\"dplyr\", repos=\"https://cran.rstudio.com\")" --no-save
# Warning: dependencies ‘graph’, ‘Rgraphviz’, ‘RBGL’ are not available
RUN R -e "install.packages(\"pcalg\", repos=\"https://cran.rstudio.com\")" --no-save
RUN R -e "packageurl <- \"https://cran.r-project.org/src/contrib/Archive/BiDAG/BiDAG_1.2.0.tar.gz\" ; install.packages(packageurl, repos=NULL, type=\"source\")" --no-save
RUN R -e "install.packages(\"bnlearn\", repos=\"https://cran.rstudio.com\")" --no-save
RUN R -e "install.packages(\"r.blip\", repos=\"https://cran.rstudio.com\")" --no-save
# For the R version of GOBNILP
RUN R -e "install.packages(\"reticulate\", repos=\"https://cran.rstudio.com\")" --no-save
RUN R -e "install.packages(\"stringr\", repos=\"https://cran.rstudio.com\")" --no-save
RUN R -e "install.packages(\"reshape\", repos=\"https://cran.rstudio.com\")" --no-save
RUN R -e "install.packages(\"gridExtra\", repos=\"https://cran.rstudio.com\")" --no-save
RUN R -e "install.packages(\"argparser\", repos=\"https://cran.rstudio.com\")" --no-save
RUN R -e "install.packages(\"rjson\", repos=\"https://cran.rstudio.com\")" --no-save
RUN sudo apt-get install -y --no-install-recommends r-base-dev xml2 libxml2-dev libssl-dev libcurl4-openssl-dev unixodbc-dev && rm -rf /var/lib/apt/lists/*;
RUN R -e "install.packages(\"devtools\")" --no-save
RUN R -e "install.packages(\"stringr\")" --no-save
RUN R -e "install.packages(\"rJava\")" --no-save

RUN mkdir /myappdir/benchmark
WORKDIR /myappdir/benchmark

ADD scripts scripts
ADD lib lib
ADD plot.ipynb .
RUN mkdir simresults
