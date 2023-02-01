FROM python:3

RUN git clone https://github.com/jakelever/pubrunner.git
RUN git clone https://github.com/jakelever/Ab3P.git
RUN git clone https://github.com/jakelever/OpenSesamIE.git
RUN pip install --no-cache-dir spacy
RUN python -m spacy download en
RUN pip install --no-cache-dir -e /pubrunner
RUN pubrunner --test --defaultsettings /Ab3P

ENV PATH="/pubrunner/openminted:${PATH}"

CMD [ "echo", "Success." ]

