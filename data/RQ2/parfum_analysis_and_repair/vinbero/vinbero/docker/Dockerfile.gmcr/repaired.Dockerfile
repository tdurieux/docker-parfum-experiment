#{{c
  github = 'https://github.com'
  branch = args.branch
  if branch ~= 'master' then
    branch = 'dev'
  end
  gonapps_repos = {'libgenc', 'libgaio', 'libfastdl'}
  vinbero_repos = {'libvinbero_com', 'vinbero-ifaces', 'vinbero'}
  all_repos = {}
  for _, repo in pairs(gonapps_repos) do
    table.insert(all_repos, repo)
  end
  for _, repo in pairs(vinbero_repos) do
    table.insert(all_repos, repo)
  end
}}#
#{{c
  if branch ~= 'master' then
    print([[
FROM golang:alpine as installer
RUN apk update && apk add --no-cache git
RUN wget https://github.com/isacikgoz/gitbatch/releases/download/v0.4.1/gitbatch_0.4.1_linux_amd64.tar.gz -O /gitbatch.tar.gz
RUN tar -xvzf /gitbatch.tar.gz -C / && rm /gitbatch.tar.gz
RUN wget 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip' -O /ngrok.zip
RUN unzip /ngrok.zip -d /
RUN go get -u github.com/git-chglog/git-chglog/cmd/git-chglog
    ]])
  end
}}#
FROM alpine:latest
MAINTAINER Byeonggon Lee (gonny952@gmail.com)

RUN apk update && apk add --no-cache git cmake automake autoconf libtool make gcc musl-dev cmocka-dev jansson-dev openssl openssl-dev clang yaml-dev
RUN mkdir -p /usr/src && rm -rf /usr/src
#{{c
  if branch ~= 'master' then
    print([[
COPY --from=installer /gitbatch /usr/bin/gitbatch
COPY --from=installer /ngrok /usr/bin/ngrok
COPY --from=installer /go/bin/git-chglog /usr/bin/git-chglog
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories; apk update
RUN apk add --no-cache tmux vim less grep curl musl-dbg gdb valgrind tree zsh procps flex-dev g++ boost-dev boost-program_options lua5.3-dev nlohmann-json uncrustify
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
COPY vimrc /etc/vim/vimrc
COPY .zshrc /root/.zshrc
COPY vinbero-dev /usr/bin/vinbero-dev
RUN chmod +x /usr/bin/vinbero-dev
RUN git config --global pager.branch false
RUN git clone -j8 --recurse-submodules https://github.com/gonapps-org/gmcr /usr/src/gmcr
RUN mkdir /usr/src/gmcr/build && rm -rf /usr/src/gmcr/build
RUN cd /usr/src/gmcr/build; cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr ..; make; make install
    ]])
  end
}}#
#{{c
  for _, repo in pairs(gonapps_repos) do
    print('RUN git clone -j8 --recurse-submodules -b ' .. branch .. ' ' .. github .. '/gonapps-org/' .. repo .. ' /usr/src/' .. repo)
  end
  for _, repo in pairs(vinbero_repos) do
    print('RUN git clone -j8 --recurse-submodules -b ' .. branch .. ' ' .. github .. '/vinbero/' .. repo .. ' /usr/src/' .. repo)
  end
}}#
#{{c
  if branch ~= 'master' then
    for _, repo in pairs(all_repos) do
      print('RUN mkdir /usr/src/' .. repo .. '/build; cd /usr/src/' .. repo .. '/build; cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_BUILD_TYPE=Debug ..; make; make test; make install')
    end
  else
    for _, repo in pairs(all_repos) do
      print('RUN mkdir /usr/src/' .. repo .. '/build; cd /usr/src/' .. repo .. '/build; cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_BUILD_TYPE=Release ..; make; make test; make install')
    end
  end
}}#
