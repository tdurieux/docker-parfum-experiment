ADD http://labs.rd.ciencias.ulisboa.pt/dishin/chebi202104.db.gz ./
RUN gunzip -N chebi202104.db.gz 
ADD http://labs.rd.ciencias.ulisboa.pt/dishin/go202104.db.gz ./
RUN gunzip -N go202104.db.gz
ADD http://labs.rd.ciencias.ulisboa.pt/dishin/hp202104.db.gz ./
RUN gunzip -N hp202104.db.gz
ADD http://labs.rd.ciencias.ulisboa.pt/dishin/doid202104.db.gz ./
RUN gunzip -N doid202104.db.gz
ADD http://labs.rd.ciencias.ulisboa.pt/dishin/mesh202104.db.gz ./
RUN gunzip -N mesh202104.db.gz
ADD http://labs.rd.ciencias.ulisboa.pt/dishin/radlex202104.db.gz ./
RUN gunzip -N radlex202104.db.gz
ADD http://labs.rd.ciencias.ulisboa.pt/dishin/wordnet202104.db.gz ./
RUN gunzip -N wordnet202104.db.gz