# name: night_day_mode.sh
# type: script
# 
##################################################################
# 
#   DOCUMENTATION
# 
##################################################################
# 
# Night-day themes and colors switch:
# 
# ===========================================
# 1. xterm colors:
# ===========================================
# 
#     1.1 Change colors in ~./Xresources file with linux command:
#         # at line about 23-24
# 
#         xterm*background: black ===> xterm*background: gray
#         xterm*foreground: green ===> xterm*foreground: black
# 
#         # commands:
#         sed -i "s/background: black/background: gray/" ~/.Xresources
#         sed -i "s/foreground: green/foreground: black/" ~/.Xresources
#         xrdb -load ~/.Xresources
# 
#             and vice versa
#         xterm*background: black ===> xterm*background: green
#         xterm*foreground: gray ===> xterm*foreground: black
# 
#         # commands:
#         sed -i "s/foreground: black/foreground: green/" ~/.Xresources
#         sed -i "s/background: gray/background: black/" ~/.Xresources
#         xrdb -load ~/.Xresources
#         
# ============================================
# 
# 
# ============================================
# 2. bashrc PS1 color switch (with xterm):
# ============================================
# 
#     2.1 PS1="[\[$blue\]\u\[$reset\] \W]$ "
# 
#         sed -i "s/$blue/$cyan/" /etc/bash.bashrc
#         source /etc/bash.bashrc
# 
#         sed -i "s/$cyan/$blue/" /etc/bash.bashrc
#         source /etc/bash.bashrc
#     
#     2.2 Define more colors
#         http://unix.stackexchange.com/a/269085
# ============================================
# 
# 
# ============================================
# 3. vim skins:
# ============================================
# 
#     3.1 Change colorscheme in vimrc
#         dark ===> bright
# 
#         sed -i "s/colorscheme desert/colorscheme ron/" ~/.vimrc
# 
#         bright ===> dark
# 
#         sed -i "s/colorscheme ron/colorscheme desert/" ~/.vimrc
# ============================================
# 
# 1,2&3 merged:
# 
# # dark ==> bright
# sed -i "s/background: black/background: gray/" ~/.Xresources
# sed -i "s/foreground: green/foreground: black/" ~/.Xresources
# xrdb -load ~/.Xresources
# sed -i "s/$cyan/$blue/" /etc/bash.bashrc
# source /etc/bash.bashrc
# sed -i "s/colorscheme desert/colorscheme ron/" ~/.vimrc
# 
# # bright ==> dark
# sed -i "s/foreground: black/foreground: green/" ~/.Xresources
# sed -i "s/background: gray/background: black/" ~/.Xresources
# xrdb -load ~/.Xresources
# sed -i "s/$blue/$cyan/" /etc/bash.bashrc
# source /etc/bash.bashrc
# sed -i "s/colorscheme ron/colorscheme desert/" ~/.vimrc

##################################################################
#
#   PROGRAM ITSELF
#

USERNAME="cereberus"
BASE="/home/$USERNAME/"

# Get the information about current stance.
current_color=$(cat $BASE.Xresources | grep xterm.background | sed "s/xterm.background: //g")

# Perform the switch depending on the current background color.
if [ "$current_color" == "black" ]; then
    # dark ==> bright
    sed -i "s/background: black/background: gray/" $BASE.Xresources
    sed -i "s/foreground: green/foreground: black/" $BASE.Xresources
    xrdb -load $BASE.Xresources
    sed -i 's/$cyan/$blue/' $BASE.bashrc
    source $BASE.bashrc
    sed -i "s/colorscheme desert/colorscheme ron/" $BASE.vimrc
    current_color="gray"
else
    # bright ==> dark
    sed -i "s/foreground: black/foreground: green/" $BASE.Xresources
    sed -i "s/background: gray/background: black/" $BASE.Xresources
    xrdb -load $BASE.Xresources
    sed -i 's/$blue/$cyan/' $BASE.bashrc
    source $BASE.bashrc
    sed -i "s/colorscheme ron/colorscheme desert/" $BASE.vimrc
    current_color="black"
fi

printf "\nCurrent color set to: === %s ===.\n" $current_color
printf "Please restart xterm in order for changes to take place.\n\n"
