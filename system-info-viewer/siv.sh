#!/bin/bash
#
# System Info Viewer
#
# Author : Levis Jani
#
#
# **** License ****
#
# The software is distributed under "THE BEER-WARE LICENSE" (Revision 42)
# The Beer-ware license was written by Poul-Henning Kamp. <phk@FreeBSD.ORG>
# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a beer in return.
# ----------------------------------------------------------------------------
#
# **** variable declaration ****
declaration(){
    # **** color ****
    c0='[0m'
    c1='[1;31m' # RED
    c2='[1;32m' # GREEN
    c3='[1;33m' # YELLOW
    c4='[1;34m' # BLUE
    c5='[1;35m' # PURPLE
    c6='[1;36m' # CYAN
    c7='[1;37m' # GRAY

    # **** info ****
    OS=$(uname -o)
    HOST=$(hostname)
    USER=$(whoami)

    UPTIME=$(</proc/uptime)
    UPTIME=${UPTIME//.*}
    SECS=$((${UPTIME}%60))
    MINS=$((${UPTIME}/60%60))
    HOURS=$((${UPTIME}/3600%24))
    DAYS=$((${UPTIME}/86400))
    UPTIME="${MINS}m ${SECS}s"
    if [ "${HOURS}" -ne "0" ]; then
	UPTIME="${HOURS}h ${UPTIME}"
	fi
    if [ "${DAYS}" -ne "0" ]; then
	UPTIME="${DAYS}d ${UPTIME}"
	fi

    KERNEL=$(uname -r)
    CPU=$(awk 'BEGIN{FS=":"} /model name/ { gsub(/  +/," ",$2); gsub(/^ /,"",$2); gsub(/\(R\)|\(TM\)/,"",$2); print $2; exit }' /proc/cpuinfo);

    MEM_INFO=$(</proc/meminfo)
    MEM_INFO=$(echo $(echo $(MEM_INFO=${MEM_INFO// /}; echo ${MEM_INFO//kB/})))
    for m in $MEM_INFO; do
	if [[ ${m//:*} = MemTotal ]]; then
	    MEMTOTAL=${m//*:}
	    fi
	if [[ ${m//:*} = MemFree ]]; then
	    MEMFREE=${m//*:}
	    fi
	if [[ ${m//:*} = Buffers ]]; then
	    MEMBUFFER=${m//*:}
	    fi
	if [[ ${m//:*} = Cached ]]; then
	    MEMCACHED=${m//*:}
	    fi
	done
    USEDMEM="$((($MEMTOTAL - $MEMFREE - $MEMBUFFER - $MEMCACHED) / 1024))"
    TOTALMEM="$(($MEMTOTAL / 1024))"
    MEM_DISPLAY="$USEDMEM / $TOTALMEM MB"

    ROOT_USED=$(df -h | grep "rootfs" | awk -v OFS=" " '$1=$1' | cut -d' ' -f3)
    ROOT_TOT=$(df -h | grep "rootfs" | awk -v OFS=" " '$1=$1' | cut -d' ' -f2)
    ROOT_PER=$(df -h | grep "rootfs" | awk -v OFS=" " '$1=$1' | cut -d' ' -f5)
    ROOT_DISPLAY="$ROOT_USED / $ROOT_TOT ($ROOT_PER)"
}

# **** lame quotes ****
lame_quote_gentoo(){
    declare -a arr_gentoo=("Its -O3 the letter, not -03 the number." "Compiling from scratch is really hyped, what makes Gentoo cool is the technical merits like rc-updating and USE flags." "Gentoo does help stop programmers from being lazy, so they write completely airtight code. That can only be a good thing, whichever way you look at it." "What other gnu/linux will let you have a vector optimized wordprocessor?" "Debian is easy to keep up to date. That's because they don't update it." "The performance gained by CFLAGS on x86 is minimal at best -- largely because the machines are still basically overclocked 386's at their core." "HOLY COW I'M TOTALLY GOING SO FAST OH F***!!" "Anyone ever wondered how larry can be a cow!" "If it moves compile it." "I use Gentoo because I'm a speed freak - I can't stand the thought that some of my packages might not be running as fast as they could be.")
    i=$(expr $RANDOM % 10)
    QUOTE_DISPLAY="${arr_gentoo[$i]}"
}

lame_quote_star_wars(){
    declare -a arr_star_wars=("Look, good against remotes is one thing, good against the living, that's something else." "Aren't you a little short for a stormtrooper?" "The Force is strong with this one." "I find your lack of faith disturbing." "May the Force be with you." "I'm Luke Skywalker, I'm here to rescue you." "Boring conversation anyway. Luke, we're gonna have company!" "You're all clear, kid! Now let's blow this thing and go home!" "You've never heard of the Millennium Falcon? ... It's the ship that made the Kessel run in less than 12 parsecs." "I am your Father..." )
    i=$(expr $RANDOM % 10)
    QUOTE_DISPLAY="${arr_star_wars[$i]}"
}

lame_quote_vader(){
    declare -a arr_vader=("I find your lack of faith disturbing." "Luke, I am your father!" "I sense something, a presence I've not felt since......." "You should not have come back!" "The ability to destroy a planet is insignificant next to the power of the force." "Just for once, let me look at your face with my own eyes." "Obi-Wan has taught you well." "He will join us or die, my master." "You have controlled your fear. Now, release your anger. Only your hatred can destroy me." "When I left you I was but the learner. Now I am the master.")
    i=$(expr $RANDOM % 10)
    QUOTE_DISPLAY="${arr_vader[$i]}"
}

lame_quote_star_trek(){
    declare -a arr_star_trek=("Fascinating." "Do you want to tell me what's bothering you or would you like to break some more furniture?" "Rumors of my assimilation are greatly exaggerated." "Spock, I do not know too much about these little Tribbles yet, but there is one thing that I have discovered. I like them ... better than I like you." "I would be delighted to offer any advice I can on understanding women. When I have some, I'll let you know." "Do that thing we just talked about." "What does god need with a starship?" "Our neural pathways have become accustomed to your sensory input patterns." "Please, Captain, not in front of the Klingons." "KHAAANNNN!")
    i=$(expr $RANDOM % 10)
    QUOTE_DISPLAY="${arr_star_trek[$i]}"
}

lame_quote_mortal_kombat(){
    declare -a arr_mk=("Vengeance will be mine!" "Finish Him!" "Your soul is mine!" "Fatality." "Every man is responsible for his own destiny." "Let the Mortal Kombat begin." "Flawless victory." "Liu Kang Wins!" "Sonya Wins!" "Scorpion and Sub-Zero. Deadliest of enemies but slaves under my power.")
    i=$(expr $RANDOM % 10)
    QUOTE_DISPLAY="${arr_mk[$i]}"
}

lame_quote_royal(){
    declare -a arr_royal=("The interpretation of dreams is the royal road to a knowledge of the unconscious activities of the mind." "The royal road to a man's heart is to talk to him about the things he treasures most." "In the past, people were born royal. Nowadays, royalty comes from what you do." "There was a knight came riding by.. In early spring, when the roads were dry." "A true knight is fuller of bravery in the midst, than in the beginning of danger." "I have played a boxer, a cowboy, a knight, a prince, an elf and a pirate. I am so glad to have done all of that already." "Heroism is endurance for one moment more." "The greatest height of heroism to which an individual, like a people, can attain is to know how to face ridicule." "Faith is the heroism of the intellect." "True heroism is remarkably sober, very undramatic.")
    i=$(expr $RANDOM % 10)
    QUOTE_DISPLAY="${arr_royal[$i]}"
}

lame_quote_batman(){
    declare -a arr_batman=("How about a magic trick?" "It's simple. We, uh, kill the Batman." "If you're good at something, never do it for free." "Some men just want to watch the world burn." "Going to see your wife? You love her?" "There won't be any fireworks!" "What were you trying to prove? That deep down, everyone's as ugly as you?! You're alone." "But the Joker cannot win. Gotham needs its true hero." "Why So Serious?" "I'm an agent of chaos.")
    i=$(expr $RANDOM % 10)
    QUOTE_DISPLAY="${arr_batman[$i]}"
}

# **** display ****
display_gentoo(){
    echo -e "\\e${c5}                                           ."
    echo "     .siv.                                d\@b"
    echo "  .d@@@@@@b.    .cd@@b.     .d@@b.   d@@@@@@@@@@@b  .d@@b.      .d@@b."
    echo "  @@@@( )@@@b d@@( )@@@.   d@@@@@@@b Q@@@@@@@P@@@P.@@@@@@@b.  .@@@@@@@b."
    echo "  Q@@@@@@@@@@B@@@@@@@@P\"  d@@@PQ@@@@b.   @@@@.   .BOOB' \`@@@ .@@@P' \`@@@"
    echo "    \"@@@@@@@P Q@@@@@@@b  d@@@P   Q@@@@b  @@@@b   @@@@b..d@@@ @@@@b..d@@@"
    echo "   d@@@@@@P\"   \"@@@@@@@@ Q@@@     Q@@@@  @@@@@   \`Q@@@@@@@P  \`Q@@@@@@@P"
    echo "  @@@@@@@P       \`\"\"\"\"\"   \"\"        \"\"   Q@@@P     \"Q@@@P\"     \"Q@@@P\""
    echo "  \`Q@@P\"                                  \"\"\""
    echo -e "\\e${c0}"
    echo -e "\\e${c4}>               \\e${c5}OS: \\e${c4}${OS}"
    echo -e "\\e${c4}>         \\e${c5}Hostname: \\e${c4}${HOST}"
    echo -e "\\e${c4}>             \\e${c5}User: \\e${c4}${USER}"
    echo -e "\\e${c4}>           \\e${c5}Uptime: \\e${c4}${UPTIME}"
    echo -e "\\e${c4}>           \\e${c5}Kernel: \\e${c4}${KERNEL}"
    echo -e "\\e${c4}>            \\e${c5}Shell: \\e${c4}${SHELL}"
    echo -e "\\e${c4}>              \\e${c5}CPU: \\e${c4}${CPU}"
    echo -e "\\e${c4}>              \\e${c5}RAM: \\e${c3}${MEM_DISPLAY}"
    echo -e "\\e${c4}>             \\e${c5}Root: \\e${c4}${ROOT_DISPLAY}"
    echo ""
    echo -e "\t\\e${c4}=>>>>\\e${c5} Lame Quote \\e${c4}<<<<="
    echo -e "\\e${c0}"
    echo -e "\\e${c4}> \\e${c3}${QUOTE_DISPLAY}\\e${c0}\n"
}

display_star_wars(){
    echo -e "\\e${c3}    .                          .                              ."
    echo -e " .             o88888888888888  d88b  .  8888888b.  .      ."
    echo -e "       .  .    Y88<\"\"\"\"888\"\"\"\" j8PY8i    888   )88     ."
    echo -e "                Y8b.   888    ,8P  Y8,   88888888'         ."
    echo -e "_________________>88b  888    88888888   888  Y8b_________________"
    echo -e ":::::::::88888888888P  888   d8P    Y8b  888   Y888888::::::::::::"
    echo -e ":::::::::(                                           )::::::::::::"
    echo -e ":::::::::Y8b  d88b  d8P  d88b   . 8888888b.  o88888888::::::::::::"
    echo -e "\"\"\"\"\"\"\"\"\"\"88ij8888ij88' j8PY8i    888   )88  Y88<\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\""
    echo -e "          \"8888PY8888' ,8P  Y8,   88888888'   Y8b.   .          ."
    echo -e "    .      Y88P  Y88P  88888888   888  Y8b_____>88b           ."
    echo -e "  .      .  Y8'  \"8P  d8P    Y8b  888   Y888888888P     ."
    echo -e "\\e${c0}"
    echo -e "\\e${c6}>               \\e${c1}OS: \\e${c6}${OS}"
    echo -e "\\e${c6}>         \\e${c1}Hostname: \\e${c6}${HOST}"
    echo -e "\\e${c6}>             \\e${c1}User: \\e${c6}${USER}"
    echo -e "\\e${c6}>           \\e${c1}Uptime: \\e${c6}${UPTIME}"
    echo -e "\\e${c6}>           \\e${c1}Kernel: \\e${c6}${KERNEL}"
    echo -e "\\e${c6}>            \\e${c1}Shell: \\e${c6}${SHELL}"
    echo -e "\\e${c6}>              \\e${c1}CPU: \\e${c6}${CPU}"
    echo -e "\\e${c6}>              \\e${c1}RAM: \\e${c3}${MEM_DISPLAY}"
    echo -e "\\e${c6}>             \\e${c1}Root: \\e${c6}${ROOT_DISPLAY}"
    echo ""
    echo -e "\t\\e${c6}=>>>>\\e${c1} Lame Quote \\e${c6}<<<<="
    echo -e "\\e${c0}"
    echo -e "\\e${c6}> \\e${c3}${QUOTE_DISPLAY}\\e${c0}\n"
}

display_star_trek(){
    echo -e "\t\\e${c3}               ."
    echo -e "\t\\e${c3}              .#."
    echo -e "\t\\e${c3}             .###."
    echo -e "\t\\e${c3}            .#####."
    echo -e "\t\\e${c6}        ***\\e${c3}.#######.\\e${c6}***"
    echo -e "\t\\e${c6}   *******\\e${c3}.#########.\\e${c6}*******"
    echo -e "\t\\e${c6} ********\\e${c3}.###########.\\e${c6}********"
    echo -e "\t\\e${c6}********\\e${c3}.#############.\\e${c6}********"
    echo -e "\t\\e${c6}*******\\e${c3}.######'\\e${c6}***\\e${c3}\`####.\\e${c6}*******"
    echo -e "\t\\e${c6}******\\e${c3}.####'\\e${c6}*********\\e${c3}\`##.\\e${c6}******"
    echo -e "\t\\e${c6} ****\\e${c3}.###'\\e${c6}*************\\e${c3}\`#.\\e${c6}****"
    echo -e "\t\\e${c6}   *\\e${c3}.##'\\e${c6}*****************\\e${c3}\`.\\e${c6}*"
    echo -e "\t\\e${c3}   .#'  \\e${c6}***************    \\e${c3}."
    echo -e "\t\\e${c3}  ."
    echo -e "\t\\e${c0}"
    echo -e "\\e${c6}>               \\e${c7}OS: \\e${c6}${OS}"
    echo -e "\\e${c6}>         \\e${c7}Hostname: \\e${c6}${HOST}"
    echo -e "\\e${c6}>             \\e${c7}User: \\e${c6}${USER}"
    echo -e "\\e${c6}>           \\e${c7}Uptime: \\e${c6}${UPTIME}"
    echo -e "\\e${c6}>           \\e${c7}Kernel: \\e${c6}${KERNEL}"
    echo -e "\\e${c6}>            \\e${c7}Shell: \\e${c6}${SHELL}"
    echo -e "\\e${c6}>              \\e${c7}CPU: \\e${c6}${CPU}"
    echo -e "\\e${c6}>              \\e${c7}RAM: \\e${c3}${MEM_DISPLAY}"
    echo -e "\\e${c6}>             \\e${c7}Root: \\e${c6}${ROOT_DISPLAY}"
    echo ""
    echo -e "\t\\e${c6}=>>>>\\e${c7} Lame Quote \\e${c6}<<<<="
    echo -e "\\e${c0}"
    echo -e "\\e${c6}> \\e${c3}${QUOTE_DISPLAY}\\e${c0}\n"
}

display_vader(){
    echo -e "\\e${c6}   _________________________________ "
    echo -e "\\e${c6}  |#############;;##################|\t\\e${c6}          \\e${c1} OS: \\e${c6}$OS"
    echo -e "\\e${c6}  |###########'~||~~~\`\`#############|\t\\e${c6}    \\e${c1} Hostname: \\e${c6}$HOST"
    echo -e "\\e${c6}  |########'   .'#     o\`###########|\t\\e${c6}        \\e${c1} User: \\e${c6}$USER"
    echo -e "\\e${c6}  |#######' oo | |o  o    ##########|\t\\e${c6}      \\e${c1} Uptime: \\e${c6}$UPTIME"
    echo -e "\\e${c6}  |####### 8  .'.'    8 o  #########|\t\\e${c6}      \\e${c1} Kernel: \\e${c6}$KERNEL"
    echo -e "\\e${c6}  |####### 8  | |     8    #########|\t\\e${c6}       \\e${c1} Shell: \\e${c6}$SHELL"
    echo -e "\\e${c6}  |####### _._| |_;...8    #########|\t\\e${c6}         \\e${c1} CPU: \\e${c6}$CPU"
    echo -e "\\e${c6}  |######'~--.   .--. \`.   \`########|\t\\e${c6}         \\e${c1} RAM: \\e${c3}${MEM_DISPLAY}"
    echo -e "\\e${c6}  |#####'     =8     ~  \ o ########|\t\\e${c6}        \\e${c1} Root: \\e${c6}${ROOT_DISPLAY}"
    echo -e "\\e${c6}  |####'       8._ 88.   \ o########|"
    echo -e "\\e${c6}  |###'   __. ;.ooo~~.    \ o\`######|"
    echo -e "\\e${c6}  |###   . -. 88\`78o/#     \  \`#####|\t\t\\e${c1}^+^+^+^+^+^+^+^+^+^+^+^+^+^"
    echo -e "\\e${c6}  |##'     /. o o \ ##      \88\`####|"
    echo -e "\\e${c6}  |#;     o|| 8 8 |d.        \`8 \`###|\t\\e${c3}            ."
    echo -e "\\e${c6}  |#.       - ^ ^ -'           \`-\`##|\t\\e${c3}           ________   ___   ____ "
    echo -e "\\e${c6}  |##.                          .###|\t\\e${c3}          / __   __| / _ \ |  _ \ "
    echo -e "\\e${c6}  |#####.....           ##'     \`\`##|\t\\e${c3}       ___> \ | |   |  _  ||    /__ "
    echo -e "\\e${c6}  |########-'\`-        88          \`|\t\\e${c3}      |_____/ |_|   |_| |_||_|\____| "
    echo -e "\\e${c6}  |#####-'.          -       ##     |\t\\e${c3}       _  _  _   ___   ____    ____ "
    echo -e "\\e${c6}  |#-~. . .                   #     |\t\\e${c3}      | |/ \| | / _ \ |  _ \. / ___| "
    echo -e "\\e${c6}  | .. .   ..#   o#8      88o       |\t\\e${c3}      |   .   ||  _  ||    /__> \ "
    echo -e "\\e${c6}  |. .     ###   8#P     d888. . .  |\t\\e${c3}       \_/ \_/ |_| |_||_|\______/   ."
    echo -e "\\e${c6}  |.   .   #88   88      888'  . .  |\t\\e${c3}      .                   ."
    echo -e "\\e${c6}  |   o8  d88P . 88   ' d88P   ..   |"
    echo -e "\\e${c6}  |  88P  888   d8P   ' 888         |\t\t\\e${c1}^+^+^+^+^+^+^+^+^+^+^+^+^+^"
    echo -e "\\e${c6}  |   8  d88P.'d#8  .- dP~ o8       |"
    echo -e "\\e${c6}  |      888   888    d~ o888       |"
    echo -e "\\e${c6}  |_________________________________|"
    echo -e "\\e${c0}"
    echo -e "\\e${c6}> \\e${c3}${QUOTE_DISPLAY}\\e${c0}\n"
}

display_mortal_kombat(){
    echo -e "\\e${c1}                                      ueeeee...^\"*@e.                 "
    echo -e "                               ur d@@@@@@@@@@@@@@Nu \"*Nu                      "
    echo -e "                             d@@@ \"@@@@@@@FUCK@@@@@@@e.\"@c                   "
    echo -e "                         u@@c   \"\"   ^\"^**@@@@@@@@@@@@@b.^R:                "
    echo -e "                       z@@#\"\"\"           \`!?@@@@@@@@@@@@@N.^               "
    echo -e "                     .@P                   ~!R@@@@@@@@@@@@@b                   "
    echo -e "                    x@F                 **@b. '\"R).@@@@@@@@@@                 "
    echo -e "                   J^\"                           #@@@@@@@@@@@@.               "
    echo -e "                  z@e                      ..      \"**@@@@@@@@@               "
    echo -e "                 :@P           .        .@@@@@b.    ..  \"  #@@@@              "
    echo -e "                 @@            L          ^*@@@@b   \"      4@@@@L             "
    echo -e "                4@@            ^u    .e@@@@e.\"*@@@N.       @@@@@@             "
    echo -e "                @@E            d@@@@@@@@@@@@@@L \"@@@@@  mu @@@@@@F            "
    echo -e "                @@&            @@@@@@@@@@@@@@@@N   \"#* * ?@@@@@@@N            "
    echo -e "                @@F            '@@@@@@@@@@@@@@@@@bec...z@ @@@@@@@@             "
    echo -e "               '@@F             \`@@@@@@@@@@@@@@@@@@@@@@@@ '@@@@E\"@           "
    echo -e "                @@                  ^\"\"\"\"\"\"\`       ^\"*@@@& 9@@@@N      "
    echo -e "                k  u@                                  \"@@. \"@@P r           "
    echo -e "                4@@@@L                                   \"@. eeeR             "
    echo -e "                 @@@@@k                                   '@e. .@              "
    echo -e "                 3@@@@@b                                   '@@@@               "
    echo -e "                  @@@@@@                                    3@@\"              "
    echo -e "                   @@@@@  dc                                4@F                "
    echo -e "                    RF** <@@                                J\"                "
    echo -e "                     #bue@@@LJ@@@Nc.                        \"                 "
    echo -e "                      ^@@@@@@@@@@@@@r                                          "
    echo -e "                        \`\"*@@@@@@@@@                                         "
    echo -e "\t\\e${c0}"
    echo -e "\\e${c2}  +---->                          \\e${c6}OS: \\e${c2}${OS}"
    echo -e "\\e${c2}   \-->                     \\e${c6}Hostname: \\e${c2}${HOST}"
    echo -e "\\e${c2}    \-->                        \\e${c6}User: \\e${c2}${USER}"
    echo -e "\\e${c2}     \-->                     \\e${c6}Uptime: \\e${c2}${UPTIME}"
    echo -e "\\e${c2}      \-->                    \\e${c6}Kernel: \\e${c2}${KERNEL}"
    echo -e "\\e${c2}       \-->                    \\e${c6}Shell: \\e${c2}${SHELL}"
    echo -e "\\e${c2}        \-->                     \\e${c6}CPU: \\e${c2}${CPU}"
    echo -e "\\e${c2}         \-->                    \\e${c6}RAM: \\e${c3}${MEM_DISPLAY}"
    echo -e "\\e${c2}          +-->                  \\e${c6}Root: \\e${c2}${ROOT_DISPLAY}"
    echo -e "\\e${c2}           \ "
    echo -e "\\e${c2}            +----> \\e${c3}${QUOTE_DISPLAY}\\e${c0}\n"
}

display_royal(){
    echo -e "\t\\e${c3}"
    echo -e "\t\\e${c3}                                .-."
    echo -e "\t\\e${c3}                               {{@}}"
    echo -e "\t\\e${c3}               <>               \\e${c2}8@8"
    echo -e "\t\\e${c3}             .::::.             \\e${c2}888"
    echo -e "\t\\e${c3}         @+\/W\/\/W\/+@         \\e${c2}8@8"
    echo -e "\t\\e${c3}          \+\/^\/^\/+/     _    \\e${c2})8(    \\e${c3}_"
    echo -e "\t\\e${c3}           \_\\e${c1}O\\e${c3}_<>_\\e${c1}O\\e${c3}_/     (@)\\e${c2}__/8@8\__\\e${c3}(@)"
    echo -e "\t      \\e${c2}________\\e${c3}____\\e${c5}________ \\e${c3}\`~\"-=\\e${c6})\\e${c2}*\\e${c6}(\\e${c3}=-\"~\`"
    echo -e "\t     \\e${c2}|\\e${c1}<><><>\\e${c2}<<\\e${c3}|%%|\\e${c5}>>\\e${c1}<><><>\\e${c5}|     \\e${c6}|.|"
    echo -e "\t     \\e${c2}|\\e${c1}<>\\e${c2}<<<<<<\\e${c3}|%%|\\e${c5}>>>>>>\\e${c1}<>\\e${c5}|     \\e${c6}|R|"
    echo -e "\t     \\e${c2}|\\e${c1}<>\\e${c2}<<<<<<\\e${c3}|%%|\\e${c5}>>>>>>\\e${c1}<>\\e${c5}|     \\e${c6}|'|"
    echo -e "\t     \\e${c2}|\\e${c1}<>\\e${c2}<<<\\e${c3}.--------.\\e${c5}>>>\\e${c1}<>\\e${c5}|     \\e${c6}|.|"
    echo -e "\t     \\e${c2}|<<<<<\\e${c3}|   ()   |\\e${c5}>>>>>\\e${c5}|     \\e${c6}|O|"
    echo -e "\t     \\e${c2}|<<<<<\\e${c3}| (\\e${c1}O\\e${c3}\/\\e${c1}O\\e${c3}) |\\e${c5}>>>>>\\e${c5}|     \\e${c6}|'|"
    echo -e "\t\\e${c3}     |%%%%%\   /\   /%%%%%|     \\e${c6}|.|"
    echo -e "\t\\e${c3}     |%%%%%%\  \/  /%%%%%%|     \\e${c6}|Y|"
    echo -e "\t\\e${c3}     \\e${c4}|<<<<<<<\\e${c3}'.__.'\\e${c6}>>>>>>>|     \\e${c6}|'|"
    echo -e "\t     \\e${c4}|<<<<<<<<\\e${c3}|%%|\\e${c6}>>>>>>>>|     \\e${c6}|.|"
    echo -e "\t     \\e${c4}:<<<<<<<<\\e${c3}|%%|\\e${c6}>>>>>>>>:     \\e${c6}|A|"
    echo -e "\t      \\e${c4}\ \\e${c1}<>\\e${c4}<<<<\\e${c3}|%%|\\e${c6}>>>>\\e${c1}<> \\e${c6}/      \\e${c6}|'|"
    echo -e "\t       \\e${c4}\ \\e${c1}<>\\e${c4}<<<\\e${c3}|%%|\\e${c6}>>>\\e${c1}<> \\e${c6}/       \\e${c6}|.|"
    echo -e "\t        \\e${c4}\ \\e${c1}<>\\e${c4}<<\\e${c3}|%%|\\e${c6}>>\\e${c1}<> \\e${c6}/        \\e${c6}|L|"
    echo -e "\t         \\e${c4}\`\ \\e${c1}<>\\e${c3}|%%|\\e${c1}<> \\e${c6}/'         \\e${c6}|'|"
    echo -e "\t           \\e${c4}\`-.\\e${c3}|%%|\\e${c6}.-\`           \\e${c6}\ /"
    echo -e "\t              \\e${c3}'--'               \\e${c6}^"
    echo -e "\\e${c0}"
    echo -e "\\e${c2}  +---->             \\e${c6}OS: \\e${c2}${OS}"
    echo -e "\\e${c2}   \-->        \\e${c6}Hostname: \\e${c2}${HOST}"
    echo -e "\\e${c2}    \-->           \\e${c6}User: \\e${c2}${USER}"
    echo -e "\\e${c2}     \-->        \\e${c6}Uptime: \\e${c2}${UPTIME}"
    echo -e "\\e${c2}      \-->       \\e${c6}Kernel: \\e${c2}${KERNEL}"
    echo -e "\\e${c2}       \-->       \\e${c6}Shell: \\e${c2}${SHELL}"
    echo -e "\\e${c2}        \-->        \\e${c6}CPU: \\e${c2}${CPU}"
    echo -e "\\e${c2}         \-->       \\e${c6}RAM: \\e${c3}${MEM_DISPLAY}"
    echo -e "\\e${c2}          +-->     \\e${c6}Root: \\e${c2}${ROOT_DISPLAY}"
    echo -e "\\e${c2}           \ "
    echo -e "\\e${c2}            +----> \\e${c3}${QUOTE_DISPLAY}\\e${c0}\n"
}

display_batman(){
    echo -e "\\e${c1}"
    echo -e "                   ..oo#00ooo..                    ..ooo00#oo.."
    echo -e "                .o#########'                          '#########o."
    echo -e "             .o#########'             .   .              '#########o."
    echo -e "           .o##########~             /#   #\              ~##########o."
    echo -e "         .{###########.              #\___/#               .###########}."
    echo -e "        o############8              .#######.               8############o"
    echo -e "       ###############              #########               ###############"
    echo -e "      o###############.             o#######o              .###############o"
    echo -e "      #################.           o{#######}o            .#################"
    echo -e "     ^##################.         J###########L          .##################^"
    echo -e "     !####################oo..oo#################oo..oo#####################!"
    echo -e "     {######################################################################}"
    echo -e "     6######################################################################?"
    echo -e "     '######################################################################'"
    echo -e "      o####################################################################o"
    echo -e "       ##############;'~'^Y###7^''o###########o''^Y###7^'~';###############"
    echo -e "       '###########'       '#'    ''#########'     '#'       '############'"
    echo -e "        !#########7         !       '#######'       !         V#########!"
    echo -e "         ^o######!                   '#####'                   !######o^"
    echo -e "           ^#####'                    #####                    '#####^"
    echo -e "             'o###'                   ^###'                   '###o'"
    echo -e "               ~###.                   ###.                  .###~"
    echo -e "                 '#;.                  '#'                  .;#'"
    echo -e "                    '.                  !                  .'"
    echo -e "\\e${c0}"
    echo -e "\\e${c6}>               \\e${c1}OS: \\e${c6}${OS}"
    echo -e "\\e${c6}>         \\e${c1}Hostname: \\e${c6}${HOST}"
    echo -e "\\e${c6}>             \\e${c1}User: \\e${c6}${USER}"
    echo -e "\\e${c6}>           \\e${c1}Uptime: \\e${c6}${UPTIME}"
    echo -e "\\e${c6}>           \\e${c1}Kernel: \\e${c6}${KERNEL}"
    echo -e "\\e${c6}>            \\e${c1}Shell: \\e${c6}${SHELL}"
    echo -e "\\e${c6}>              \\e${c1}CPU: \\e${c6}${CPU}"
    echo -e "\\e${c6}>              \\e${c1}RAM: \\e${c3}${MEM_DISPLAY}"
    echo -e "\\e${c6}>             \\e${c1}Root: \\e${c6}${ROOT_DISPLAY}"
    echo ""
    echo -e "\t\\e${c6}=>>>>\\e${c1} Lame Quote \\e${c6}<<<<="
    echo -e "\\e${c0}"
    echo -e "\\e${c6}> \\e${c3}${QUOTE_DISPLAY}\\e${c0}\n"
}

# **** Fuck it ****
arg=$1
case $arg in
    -g){
	    declaration
            OS='Gentoo Gnu/Linux'
	    lame_quote_gentoo
	    display_gentoo
	};;
    -s){
	    declaration
            lame_quote_star_wars
            display_star_wars
	};;
    -v){
	    declaration
            lame_quote_vader
            display_vader
	};;
    -t){
	    declaration
            lame_quote_star_trek
            display_star_trek
	};;
    -m){
	    declaration
            lame_quote_mortal_kombat
            display_mortal_kombat
	};;
    -r){
            declaration
	    OS='Linux Royal'
            lame_quote_royal
            display_royal
        };;
    -b){
            declaration
            lame_quote_batman
            display_batman
        };;
    -h){
	    echo -e "SIV : System Information Viewer\n"
	    echo "Usage: /path/to/siv [argument]"
	    echo "List of arguments,"
	    echo -e "\t-g >\tGentoo Linux Theme"
	    echo -e "\t-s >\tStar Wars Theme"
	    echo -e "\t-v >\tDarth Vader Theme"
	    echo -e "\t-t >\tStar Trek Theme"
	    echo -e "\t-m >\tMortal Kombat Theme"
	    echo -e "\t-r >\tLinux Royal Theme"
	    echo -e "\t-b >\tBatman Theme"
	    echo -e "\t-h >\tShow Help"
	    echo "Example: /path/to/siv -g"
	};;
    *){
	    echo -e "SIV : System Information Viewer\n"
	    echo "Usage: /path/to/siv [argument]"
	    echo "List of arguments,"
	    echo -e "\t-g >\tGentoo Linux Theme"
	    echo -e "\t-s >\tStar Wars Theme"
	    echo -e "\t-v >\tDarth Vader Theme"
	    echo -e "\t-t >\tStar Trek Theme"
	    echo -e "\t-m >\tMortal Kombat Theme"
	    echo -e "\t-r >\tLinux Royal Theme"
	    echo -e "\t-b >\tBatman Theme"
	    echo -e "\t-h >\tShow Help"
	    echo "Example: /path/to/siv -g"
	};;
esac
# EOF
