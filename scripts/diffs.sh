cat data/$1-score | sort -rn | head -30 | cut -d' ' -f2 > today
cat data/$2-score | sort -rn | head -30 | cut -d' ' -f2 > yesterday

cat -n today > today-nr
cat -n yesterday > yesterday-nr

declare -A yesterday
declare -A diffs

# store yesterday position in memory
while IFS="" read -r line || [ -n "$line" ]
do
	read -r position name <<< "$line"
	yesterday["$name"]=$position
done < "yesterday-nr"

# read differences
while IFS="" read -r line || [ -n "$line" ]
do
	read -r stars name <<< "$line"
	diffs["$name"]=$stars
done < "data/$1-score"

printf '<div align="center">\n\n'

echo "|Current|Yesterday|Repository|Stars|Up/Dn|"
echo "|:---:|:---:|:---:|:---|:---:|"
#draw chart
while IFS="" read -r line || [ -n "$line" ]
do
	read -r position name <<< "$line"
	last=${yesterday["$name"]}
	stars=${diffs["$name"]}
    move=""
    if ((position < last))
    then
        move="🔼"
    elif ((position > last))
    then
        move="🔽"
    else
        move="-"
    fi
    echo "|$move|$position|${last:--}|[https://github.com/$name]($name)|+$stars|"
done < "today-nr"

printf '\n\n<div>\n'



