node default{
 include role::dev_machine 
} 

node /slave\d\.puppet/{
 include role::web_server
}
