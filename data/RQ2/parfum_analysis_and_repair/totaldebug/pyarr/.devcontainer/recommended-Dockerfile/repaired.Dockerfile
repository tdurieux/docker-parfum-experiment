FROM python:latest

RUN apt update && apt install --no-install-recommends zsh python3-sphinx -y && rm -rf /var/lib/apt/lists/*;
RUN apt upgrade  -y



RUN pip install --no-cache-dir --user poetry
ENV PATH="${PATH}:/root/.local/bin"

RUN wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O - | zsh || true
RUN poetry completions zsh > ~/.zfunc/_poetry

CMD ["zsh"]
