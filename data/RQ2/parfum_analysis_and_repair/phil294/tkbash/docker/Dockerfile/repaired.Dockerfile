FROM debian
ENV DISPLAY :0
RUN apt-get update && apt-get install --no-install-recommends -y tk git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/phil294/tkbash
COPY guibuilder.sh .
RUN ln -s /tkbash/tkbash /bin
CMD ./guibuilder.sh