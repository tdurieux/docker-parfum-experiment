FROM circleci/python:3.6
RUN sudo apt update && sudo apt install texlive texlive-xetex texlive-fonts-extra texlive-latex-extra texlive-plain-extra latexmk graphviz
ADD ./requirements /
RUN pip install --user -r /automated-documentation-tests.txt


