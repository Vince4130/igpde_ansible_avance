#! /bin/sh

result_curl=$(curl -s http://10.92.202.33:50000)
#echo ${result_curl[@]}
ip_adress=$(cat /etc/hosts)
tabhost=("")

    for hosts in ${result_curl[@]}
    do
      $tabhost=($hosts )
    done

echo ${tabhost[@]}
echo {
echo "   ""_meta": {""
echo "       " "hostvars": {}""
echo "   },"
echo "   "test": {"
echo  -n "            "hosts": ["
        for hosts in ${result_curl[@]}
        do 
            if [ $hosts == "rocky2" ]; then 
                echo -n " $hosts" ,
            else
                echo -n " $hosts"
            fi
        done
echo " ]"
echo "   }"
echo "}"
#echo $ip_adress



