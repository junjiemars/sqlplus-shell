define link_name=DL_ZD
define user_name=xwmall
define user_pwd=ydzd456123
define host_prot=tcp
define host_addr=10.32.122.17
define host_port=1521
define host_sid=ecpdb1
 
CREATE DATABASE LINK &&link_name 
   CONNECT TO &&user_name IDENTIFIED BY &&user_pwd 
   USING '(DESCRIPTION =
       (ADDRESS_LIST =
         (ADDRESS = (PROTOCOL = &&host_prot)(HOST = &&host_addr)(PORT = &&host_port))
       )
       (CONNECT_DATA =
         (SID = &&host_sid)
       )
     )'
;
/
