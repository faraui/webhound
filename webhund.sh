#!/bin/sh

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

URL="http$PROTOCOL://$ACE_DOMAIN"


############
# netcraft #
############
firefox "https://sitereport.netcraft.com/?url=$URL"
( sleep 16; xdotool key ctrl+s
sleep 1; xdotool key BackSpace; sleep 0.5; xdotool type "$PWD/ZVhfCpi"
sleep 0.5; xdotool key Return; sleep 1; xdotool key Return
sleep 3; xdotool key alt+Tab; tac ZVhfCpi.html | \
sed '1,/dark-gray/d; /background_table_section/,/$d/d;
/geolocation_map/,/geolocation_section/d; /webbug_graph/,/webbug_graphs/d;
/Not Present\|Unknown\|unknown/,/<tr/d' | tac | \
sed -z 's/\n//g; s/>\s*</></g; s/>,\s*</>,</g; s/>.\s*</>.</g' > \
netcraft_$UTF_DOMAIN.html; rm -rf ZVhfCpi*; echo "[+] netcraft" ) &


#######
# dig #
#######
for ((i=1; i<=99; i++)); do
  TYPE="TYPE$(printf "%02d" $i)"
  dig $ACE_DOMAIN -t $TYPE +noall +answer >> dig_$UTF_DOMAIN.txt
done
echo "[+] dig"


#########
# whois #
#########
whois -H $ACE_DOMAIN | sed '/^%/d; /^$/d' > whois_$UTF_DOMAIN.txt
echo "[+] whois"


###########
# wafw00f #
###########
sudo wafw00f -a -v -o wafw00f_$UTF_DOMAIN.txt $ACE_DOMAIN 2>/dev/null | \
grep -A 10000 'ing Toolkit' | sed '1d' > wafw00f_$UTF_DOMAIN.txt
echo "[+] wafw00f"


###########
# whatweb #
###########
whatweb -a 1 $URL  --log-brief=whatweb_$UTF_DOMAIN.txt >/dev/null
echo "[+] whatweb"


##########
# katana #
##########
katana -u $URL -o katana_$UTF_DOMAIN.txt >/dev/null 2>&1
cp katana_$UTF_DOMAIN.txt urls-tmp_$UTF_DOMAIN.txt 
echo "[+] katana"


#############
# dirsearch #
#############
echo '[ ] dirsearch in progress'
dirsearch -u $URL -o dirsearch_$UTF_DOMAIN.txt -t 3 >/dev/null 2>&1
cat dirsearch_$UTF_DOMAIN.txt | tr -s ' ' | cut -f 3 -d ' ' >> urls-tmp_$UTF_DOMAIN.txt
cat urls-tmp_$UTF_DOMAIN.txt | sort -u | rg http  > urls_$UTF_DOMAIN.txt; rm urls-tmp*.txt 
echo "[+] dirsearch"

######


files=( * )
for file in "${files[@]}"; do
  dir="${file#*_}"; dir="${dir%.*}"
  mkdir -p "$dir"; mv "$file" "$dir"
done
mv webhund/webhund.sh .; rmdir webhund


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
