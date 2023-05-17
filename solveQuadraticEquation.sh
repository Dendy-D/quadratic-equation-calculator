#! /bin/bash

# improve the readability of certain pieces of text
format_text_with_underline () {
  echo "$(tput setaf $2)$(tput bold)$(tput smul)$1$(tput sgr0)"
}

format_text () {
  echo "$(tput setaf $2)$(tput bold)$1$(tput sgr0)"
}

remove_trailing_decimal_point () {
  echo $1 | sed 's/[.][0]*$//g'
}

remove_surplus_zero () {
  if [ ${1: -1} -eq 0 ]; then
    echo ${1::-1}
  else
    echo $1
  fi
}

echo -e "\nLemme solve your quadratic equation amigo\nInput $(format_text_with_underline a 11), $(format_text_with_underline b 11), and $(format_text_with_underline c 11)\n"

# check if parameter is integer or float
is_number () {
  if [[ $1 =~ ^[-]?([0-9]+([.][0-9]*)?|[.][0-9]+)$ ]]; then
    echo true
  fi
}

# declare an associative array
declare -A parameters=(
  [a]=""
  [b]=""
  [c]=""
)
 
rebukes=(
  "Sorry dude, but you have to input an $(format_text_with_underline number 1)"
  "Brodie listen to me.. number.., you have to type an $(format_text_with_underline number 1)"
  "Nah brah, look a' me and try to get the point. You need to put here a dammit $(format_text_with_underline number 1)"
  "Jesus Christ man, are you kidding me? Don't make me spell it out again: $(format_text_with_underline number 1)"
)

get_random_rebuke () {
  echo ${rebukes[$((RANDOM % ${#rebukes[@]}))]}
}

sorted_parameters=( $( echo ${!parameters[@]} | tr ' ' $'\n' | sort ) )

# prompt the user for a, b and c numbers and if something is wrong, send a warning and prompt the user for input again 
for i in ${sorted_parameters[@]}; do
  read -p "$(format_text_with_underline $i 11): " param

  parameters[$i]=$param

  while ! [ $(is_number ${parameters[$i]}) ]
  do
    get_random_rebuke
    read -p "$(format_text_with_underline $i 11): " param
    parameters[$i]=$param
  done
done

discriminant=$( bc <<< "scale=2; (${parameters[b]} ^ 2) - 4 * ${parameters[a]} * ${parameters[c]}" )

if [ $( bc <<< "scale=2; $discriminant > 0" ) -eq 1 ]; then
  echo -e "\nResults:"

  x1=$( bc <<< "scale=2; (-${parameters[b]} + sqrt($discriminant)) / (2 * ${parameters[a]})" )
  x2=$( bc <<< "scale=2; (-${parameters[b]} - sqrt($discriminant)) / (2 * ${parameters[a]})" )

  echo -e "\n$(format_text x1 11) = $(format_text $(remove_surplus_zero "$(remove_trailing_decimal_point $x1)") 11)\n$(format_text x2 11) = $(format_text $(remove_surplus_zero "$(remove_trailing_decimal_point $x2)") 11)\n"

  exit
elif [ $( bc <<< "scale=2; $discriminant < 0" ) -eq 1 ]; then
  echo -e "\n$(tput setaf 11)$(tput bold)Unfortunately your discriminant is less than 0. $(tput setaf 16)$(tput setab 11)The equation is unsolvable$(tput sgr0)\n"

  exit 
elif [ $( bc <<< "scale=2; $discriminant == 0" ) -eq 1 ]; then 
  x=$( bc <<< "scale=2; -${parameters[b]} / (2 * ${parameters[a]})" )

  echo -e "\n$(format_text x 11) = $(format_text $(remove_surplus_zero "$(remove_trailing_decimal_point $x)") 11)\n"

  exit
fi
