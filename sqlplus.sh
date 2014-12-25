# sqlplus wrapper
SQLPATH="/opt/sql"
export SQLPATH

if [ $# -eq 0 ] ; then
	rlwrap sqlplus system/Hell0
else 
	rlwrap sqlplus $@
fi

# remote:
# sqlplus sms_search/sms123@10.32.65.238:1521/orcl

