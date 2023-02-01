FROM python
ENV PYTHONPATH=.

# install deps
RUN apt update -y && apt install --no-install-recommends curl zsh git -y && rm -rf /var/lib/apt/lists/*;
# poetry, ohMyZsh
RUN curl -f -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# setting vscode editor for git
RUN git config --global core.editor 'code --wait'
