#!/bin/bash
# shell script to prepend i3status with weather

# Temperature as entries in a list
temps[35]="#FF0000";
temps[34]="#FF1400";
temps[33]="#FF2800";
temps[32]="#FF3C00";
temps[31]="#FF5000";
temps[30]="#FF6400";
temps[29]="#FF7800";
temps[28]="#FF8C00";
temps[27]="#FFA000";
temps[26]="#FFB400";
temps[25]="#FFC800";
temps[24]="#FFDC00";
temps[23]="#FFF000";
temps[22]="#FDFF00";
temps[21]="#B0FF00";
temps[20]="#65FF00";
temps[19]="#3EFF00";
temps[18]="#17FF00";
temps[17]="#00FF10";
temps[16]="#00FF36";
temps[15]="#00FF5C";
temps[14]="#00FF83";
temps[13]="#00FFA8";
temps[12]="#00FFD0";
temps[11]="#00FFF4";
temps[10]="#00E4FF";
temps[9]="#00D4FF";
temps[8]="#00C4FF";
temps[7]="#00B4FF";
temps[6]="#00A4FF";
temps[5]="#0094FF";
temps[4]="#0084FF";
temps[3]="#0074FF";
temps[2]="#0064FF";
temps[1]="#0054FF";
temps[0]="#0044FF";

# This looks ugly, but I have to represent minus values somehow. 
# Hopefully climate change never gets that bad
temps[101]="#0032FF";
temps[102]="#0022FF";
temps[103]="#0012FF";
temps[104]="#0002FF";
temps[105]="#0000FF";
temps[106]="#0100FF";
temps[107]="#0200FF";
temps[108]="#0300FF";
temps[109]="#0400FF";
temps[110]="#0500FF";
temps[111]="#0600FF";


i3status -c ~/.config/i3/i3status.conf | (read line && echo "$line" && read line && 
    echo "$line" && read line && echo "$line" && while :
do
    read line
    weather=$(head -n 1 ~/.weather.cache)
    color="#FDFF01"
    [[ ${weather} == *"<"* ]] && weather="Not Available now"
    [[ ${weather:0:16} == "Unknown location" ]] && weather="Unknown location"

    end=${weather: -5}

    [[ ${weather} =~ -*([0-9]) ]] && temp=${BASH_REMATCH[1]}+30

    color="${temps[$temp]}"

    vpnconnresponse=$(curl -s https://am.i.mullvad.net/connected)
    response=""
    colour="#00FF00"
    [[ $vpnconnresponse == *"not connected"* ]] && response="⚠" && colour="#FF0000"
    [[ $vpnconnresponse == *"are connected"* ]] && IFS=' ', read -r -a vpnconn <<< "${vpnconnresponse}" && cutted=$(echo ${vpnconn[6]} | sed 's/..$//') && response="${cutted} 📡 ${vpnconn[11]}"
    
    echo ",[{\"full_text\":\"${response}\",\"color\":\"$colour\" },{\"full_text\":\"${weather}\",\"color\":\"$color\" },${line#,\[}" || exit 1
done)
