
rm score-output

declare -A stars

while IFS="" read -r line || [ -n "$line" ]
do
	read -r part1 part2 <<< "$line"
	stars["$part2"]=$part1
done < "$1"

while IFS="" read -r line || [ -n "$line" ]
do
	read -r part1 part2 <<< "$line"
	num1=${stars["$part2"]}
	echo "$(($num1-$part1)) $part2" >> score-output
done < "$2"

