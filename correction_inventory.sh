#! /bin/sh

getopt=$(getopt -n $0 -o '' --longoptions list,host: -- "$@")

if [ $? -ne 0 ]
then
	exit 1
fi

list=0
host=''

eval set -- "$getopt"

while true
do
	case $1 in
		--list )
                list=1
                shift
                ;;
		--host )
                host=$2
                shift 2
                ;;
		-- )
                shift
                break
                ;;
	esac
done

if [ \( $list -eq 1 -a -n "$host" \) -o $# -ne 0 ]
then
	echo "usage: $0 [--list | --host <nom d'hÃ´te>]" > /dev/stderr
	exit 1
fi

curl=$( curl -s http://localhost:50000/ )

cat << FIN
{
	"_meta": {
		"hostvars": {
FIN

suite=0
for machine in $curl
do
	if [ -n "$host" -a "$machine" != "$host" ]
	then
		continue
	fi

	if [ $suite -eq 0 ]
	then
		suite=1
	else
		echo ','
	fi

	cat << FIN
			"$machine": {
				"ansible_user": "$machine"
			}
FIN
done

cat << FIN
		}
	} ,
	"test": {
FIN

echo -n '		"hosts": [ '

suite=0
for machine in $curl
do
	if [ -n "$host" -a "$machine" != "$host" ]
	then
		continue
	fi

	if [ $suite -eq 0 ]
	then
		suite=1
		echo -n "\"$machine\""
	else
		echo -n " , \"$machine\""
	fi
done

echo ' ]'

cat << FIN
	}
}
FIN
