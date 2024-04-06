cat data/$1-score | sort -rn | head -30 | cut -d' ' -f2 > today
cat data/$2-score | sort -rn | head -30 | cut -d' ' -f2 > yesterday

cat -n today > today-nr
cat -n yesterday > yesterday-nr

declare -A yesterday

# store yesterday position in memory
while IFS="" read -r line || [ -n "$line" ]
do
	read -r position name <<< "$line"
	yesterday["$name"]=$position
done < "yesterday-nr"

echo "|Current|Yesterday|Repository|Change|"
echo "|:---:|:---:|:---|:---:|"
#draw chart
while IFS="" read -r line || [ -n "$line" ]
do
	read -r position name <<< "$line"
	last=${yesterday["$name"]}
    move=""
    if ((position < last))
    then
        move="⬆️"
    elif ((position > last))
    then
        move="⬇️"
    else
        move="-"
    fi

    echo "|$position|${last:--}|$name|$move|"
done < "today-nr"




