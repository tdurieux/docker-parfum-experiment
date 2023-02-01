FROM ubuntu:14.04

RUN apt-get update -qy && apt-get install --no-install-recommends tmux zsh weechat-curses -y && rm -rf /var/lib/apt/lists/*;

ADD .weechat /.weechat
ADD .tmux.conf /
RUN echo "export TERM=screen-256color" >/.zshenv

CMD zsh -c weechat
