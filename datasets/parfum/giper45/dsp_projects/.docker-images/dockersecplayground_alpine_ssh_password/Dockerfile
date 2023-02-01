FROM gotechnies/alpine-ssh 

COPY adduser.sh /adduser.sh
COPY setgw.sh /setgw.sh
COPY addctf.sh /addctf.sh
COPY exec.sh /exec.sh

LABEL \
        ports="22" \
	type="host" \
        caps_add="NET_ADMIN" \
	actions.exec.command="/exec.sh " \ 
      actions.exec.description="Execute a command in the container" \ 
      actions.exec.args.command.val="mkdir hello" \
      actions.exec.args.command.type="text" \

      actions.adduser.command="/adduser.sh" \ 
      actions.adduser.description="Add a new username : <name> <password> " \ 
      actions.adduser.args.name.val="user" \
      actions.adduser.args.name.type="text" \
      actions.adduser.args.name.rule.pattern="^[a-zA-Z0-9_-]+$" \
      actions.adduser.args.password.val="password" \
      actions.adduser.args.password.type="text" \
      actions.adduser.args.password.rule.pattern="^[a-zA-Z0-9_-]+$" \

	actions.addctf.command="/addctf.sh" \ 
      actions.addctf.description="Add a ctf in /home/<username> directory inside a secret file" \ 
      actions.addctf.args.username.val="" \
      actions.addctf.args.username.type="text" \
      actions.addctf.args.username.rule.pattern="^[a-zA-Z0-9_-]+$" \
      actions.addctf.args.ctf.val="" \
      actions.addctf.args.ctf.type="text" \

      actions.setgw.command="/setgw.sh" \ 
      actions.setgw.description="Set default gateway  <name container gateway> " \ 
      actions.setgw.args.gateway.val="" \
      actions.setgw.args.gateway.type="text" \
      actions.setgw.args.gateway.rule.pattern="^[a-zA-Z0-9_-]+$" \
