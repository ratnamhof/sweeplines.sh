#!/usr/bin/env bash
# Sweeping Lines Terminal Screensaver
# Copyright (c) 2018 Yu-Jie Lin
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

trap 'echo -e "\e[0m"; stty echo; tput cnorm; clear; exit' EXIT INT
trap 'exit' SIGWINCH
stty -echo
tput civis

# window size
W=($(tput cols) $(tput lines))

# line position (\e[y;xH is 1-based)
#P=(1 1)

# sweeping direction / increment (inc-x, inc-y)
D=(1 1)
# line symbols
# dir symbol inc-x   -y       idx = (ix * iy + 1) / 2
#  NE      \     1 * -1 = -1    0
#  SW      \    -1 *  1 = -1    0
#  NW      /    -1 * -1 =  1    1
#  SE      /     1 *  1 =  1    1
L='\/'
c=( "\e[96m" "\e[31m" "\e[32m" "\e[34m" "\e[36m" "\e[35m" "\e[33m" "\e[94m" )

randompoint(){
    s=()
    jstart=$j
    clear
    if ((p[0]==1||P[0]==W[0])); then
        P=( $((D[0]>0?1:W[0])) $((1+RANDOM%W[1])) )
    else
        P=( $((1+RANDOM%W[0])) $((D[1]>0?1:W[1])) )
    fi
}

randompoint
j=0
jstart=0
t=5
while REPLY=; do
    read -t 0.0$t -n 1 2>/dev/null
    case "$REPLY" in
        p|P) randompoint;;
        f|F) ((t=t>1?t-1:t));;
        d|D) ((t=t<9?t+1:t));;
        =) t=5;;
        ?) read -t 0.001 && cat </dev/stdin>/dev/null; break;;
    esac
    s=( ${s[@]} $((P[0]+(P[1]-1)*W[0])) )
    ((i = (D[0] * D[1] + 1) / 2))
    echo -ne "${c[j%${#c[@]}]}\e[${P[1]};${P[0]}H${L:i:1}"
    for i in 0 1; do
        # sweeping by one step
        ((P[i] += D[i]))
        # if out of bound, flip the direction (by * -1), and use the new
        # direction value to compensate to get back into the boundary
        ((P[i] < 1 || P[i] > W[i])) && ((D[i] *= -1, P[i] += D[i]))
    done
    if [[ " ${s[@]} " =~ " $((P[0]+(P[1]-1)*W[0])) " ]]; then
        s=()
        j=$(((j+1)%${#c[@]}))
        if ((j-jstart==0)); then
            randompoint
        fi
    fi
done

