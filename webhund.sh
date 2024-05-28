#!/bin/bash
sudo echo -n

while true; do
    read -p "Domain? [example.org] " UTF_DOMAIN
    UTF_DOMAIN=$(echo $UTF_DOMAIN | sed 's/\(.*\)/\L\1/')
    ACE_DOMAIN=$(idn $UTF_DOMAIN)
    IP_ADRESS=$(dig $ACE_DOMAIN +short)
    if [[ -z $IP_ADRESS ]]; then
        echo "    ERROR. Incorrect domain." >&2
    else
        break
    fi
done

read -p "httpS? [y/n] " PROTOCOL
if [[ $PROTOCOL =~ ^[nNmMbBтТьЬиИ] ]]; then PROTOCOL=""; else PROTOCOL="s"; fi
echo


############
# netcraft #
############
firefox "https://sitereport.netcraft.com/?url=http$PROTOCOL://$ACE_DOMAIN"
( sleep 16; xdotool key ctrl+s
sleep 1; xdotool key BackSpace; sleep 0.5; xdotool type "$PWD/ZVhfCpi"
sleep 0.5; xdotool key Return; sleep 1; xdotool key Return
sleep 3; xdotool key alt+Tab; tac ZVhfCpi.html | \
sed '1,/dark-gray/d; /background_table_section/,/$d/d;
/geolocation_map/,/geolocation_section/d; /webbug_graph/,/webbug_graphs/d;
/Not Present\|Unknown\|unknown/,/<tr/d' | tac | \
sed -z 's/\n//g; s/>\s*</></g; s/>,\s*</>,</g; s/>.\s*</>.</g' > \
$(echo $UTF_DOMAIN)_netcraft.html; rm -rf ZVhfCpi*; echo "[+] netcraft" ) &


#######
# dig #
#######
for ((i=1; i<=99; i++)); do
    TYPE="TYPE$(printf "%02d" $i)"
    dig $ACE_DOMAIN -t $TYPE +noall +answer >> $(echo $UTF_DOMAIN)_dig.txt
done
echo "[+] dig"


#########
# whois #
#########
whois -H $ACE_DOMAIN | sed '/^%/d; /^$/d' > $(echo $UTF_DOMAIN)_whois.txt
echo "[+] whois"


###########
# wafw00f #
###########
sudo wafw00f -a -v -o $(echo $UTF_DOMAIN)_wafw00f.txt $ACE_DOMAIN 2>/dev/null | \
grep -A 10000 'ing Toolkit' | sed '1d' > $(echo $UTF_DOMAIN)_wafw00f.txt
echo "[+] wafw00f"


###########
# whatweb #
###########
whatweb -a 1 http$PROTOCOL://$ACE_DOMAIN/  --log-brief=$(echo $UTF_DOMAIN)_whatweb.txt >/dev/null
echo "[+] whatweb"


##########
# katana #
##########
katana -u http$PROTOCOL://$ACE_DOMAIN/ -o $(echo $UTF_DOMAIN)_katana.txt >/dev/null 2>&1
cp $(echo $UTF_DOMAIN)_katana.txt $(echo $UTF_DOMAIN)_urls_temp.txt 
echo "[+] katana"


#############
# dirsearch #
#############
echo '[ ] dirsearch in progress'
dirsearch -u http$PROTOCOL://$ACE_DOMAIN/ -o $(echo $UTF_DOMAIN)_dirsearch.txt -t 3 >/dev/null 2>&1
cat $(echo $UTF_DOMAIN)_dirsearch.txt | tr -s ' ' | cut -f 3 -d ' ' >> $(echo $UTF_DOMAIN)_urls_temp.txt
cat $(echo $UTF_DOMAIN)_urls_temp.txt | sort -u | rg http  > $(echo $UTF_DOMAIN)_urls.txt; rm $(echo $UTF_DOMAIN)_urls_temp.txt 
echo "[+] dirsearch"

######


######


######


######


######


######


######


######


######


######


######


######


######


######


######


######


######


######


######


######


######


######


######


######


######


######


######


######


######

######
wait #
######
