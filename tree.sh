#!/bin/bash
trap "tput reset; tput cnorm; exit" 2
clear
tput civis

# ===============================
# CONFIGURAÇÕES PRINCIPAIS
# ===============================
lin=2
col=$(($(tput cols) / 2))
c=$((col-1))
trunk_col=$((c-2))
color=0

# ===============================
# ÁRVORE (30 linhas agora)
# ===============================
tput setaf 2; tput bold

for ((i=1; i<30; i+=2)); do
    tput cup $lin $col
    for ((j=1; j<=i; j++)); do
        echo -n "*"
    done
    ((lin++))
    ((col--))
done

tput sgr0; tput setaf 3

# ===============================
# TRONCO DA ÁRVORE
# ===============================
for ((i=1; i<=3; i++)); do
    tput cup $((lin++)) $c
    echo "mWm"
done

# ===============================
# MENSAGENS (PT-BR)
# ===============================
proximo_ano=$(date +%Y)
((proximo_ano++))

tput setaf 1; tput bold
tput cup $lin $((c - 10)); echo "FELIZ NATAL"
tput cup $((lin + 1)) $((c - 15)); echo "E MUITO CÓDIGO EM $proximo_ano!"

# ===============================
# ARRAYS PARA LUZES
# ===============================
declare -A line
declare -A column

let c++

k=1

# ===============================
# ILUMINAÇÃO PISCANTE AUTOMÁTICA
# ===============================
while true; do
    for ((i=1; i<=40; i++)); do

        # Apaga a luz anterior
        if [[ $k -gt 1 ]]; then
            idx=$((k-1))
            if [[ -n "${line[$idx,$i]}" ]]; then
                tput setaf 2; tput bold
                tput cup "${line[$idx,$i]}" "${column[$idx,$i]}"
                echo "*"
                unset line[$idx,$i]
                unset column[$idx,$i]
            fi
        fi

        # Calcula região de luz
        li=$((RANDOM % 15 + 3))    # Linha aleatória da árvore
        base=$((c - li + 2))
        co=$((RANDOM % (li-2) * 2 + 1 + base))

        # Desenha luz
        tput setaf $color; tput bold
        tput cup $li $co
        echo "o"

        line[$k,$i]=$li
        column[$k,$i]=$co

        color=$(((color + 1) % 8))

        # Texto “CÓDIGO” piscando
        txt="CÓDIGO"
        pos=1
        for ((p=0; p<${#txt}; p++)); do
            tput cup $((lin+1)) $((c + pos))
            echo -n "${txt:$p:1}"
            ((pos++))
            sleep 0.01
        done

    done

    # Alterna buffer para piscar luzes
    k=$(( (k % 2) + 1 ))
done
