#!/bin/bash
passcode=""
dmpdir=""
dmpname=""
tables=""
sqllike=""
sqlexclude=""
debug=false

while getopts "hp:dn:t:s:" arg;
do
	case ${arg} in
		h) echo "usage: -h -p<passcode> -d<dmpdir> -n<dmpname> -t<tables> -s<sqllike> -x<exclue>";;
		p) passcode=${OPTARG};;
		d) dmpdir=${OPTARG};;
		n) dmpname=${OPTARG};;
		t) tables=${OPTARG};;
		s) sqllike=${OPTARG};;
		#x) sqlexclude=${OPTARG};;
	esac
done

#echo ${dmpname}
passcode="${passcode:-system/Hell0@localhost:1521/XE}"
dmpdir="${dmpdir:-/home/junjie/cache/xe}"
dmpname="${dmpname:-tables}"
sqlexclude=""
today=`date +%Y-%m-%d`
dmpfile="${dmpdir}/dump-${dmpname}-${today}.dmp"
logfile="${dmpdir}/dump-${dmpname}-${today}.log"
tablesfile=".tables"

function build_tables() {

echo "${sqllike}"
#echo "${sqlexclude}"
sqlplus ${passcode} <<!
set heading off;
set echo off;
set pages 1000
set long 90000;
define tables_output='${tablesfile}';
define sql_like='${sqllike}';
define sql_exclude='${sqlexclude}';
spool '&tables_output'
select table_name from user_tables where table_name like '&sql_like';
spool off
exit
!

if [ -f ${tablesfile} ]; then
	_trimed="${tablesfile}-trimed"
	cat ${tablesfile} | sed '1,4d' | sed -e :a -e '$d;N;2,4ba' -e 'P;D' | sed 's/[ \t]*$//' | tr '\n' ',' | sed '$s/.$//' > ${_trimed}
	if [ -f ${_trimed} ]; then
		tables=`cat ${_trimed}`
	fi 
fi
}

if [[ -z "${tables}" && -z "${sqllike}" ]]; then
	echo "-t<tables> or -s<sqllike> cannot be null"
	exit
fi

if [ -n "${sqllike}" ]; then
	build_tables
fi
#echo "exp ${passcode} file=${dmpfile} log=${logfile} tables=${tables} sqllike=${sqllike}"
exp ${passcode} file=${dmpfile} log=${logfile} tables=${tables}

