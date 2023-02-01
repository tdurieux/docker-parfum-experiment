FROM sspreitzer/shellinabox 

COPY addroute.sh  /addroute.sh

LABEL ports="4200" \
      type="entry_point" \
      caps_add="NET_ADMIN" \
      actions.addroute.command="/addroute.sh" \ 
      actions.addroute.description="Add a new route for the subnet : set router ip and subnet " \ 
      actions.addroute.args.subnet.val="192.168.1.0/24" \
      actions.addroute.args.subnet.rule.name="subnet" \
      actions.addroute.args.subnet.type="text" \
      actions.addroute.args.router_ip.val="" \
      actions.addroute.args.router_ip.rule.name="ip" \
      actions.addroute.args.router_ip.type="text" 
