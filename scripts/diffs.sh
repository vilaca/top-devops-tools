cat data/$1-score | sort -rn | head -30 | cut -d' ' -f2 > today
cat data/$2-score | sort -rn | head -30 | cut -d' ' -f2 > yesterday

cat -n today > today-nr
cat -n yesterday > yesterday-nr

declare -A yesterday
declare -A diffs
declare -A stars

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

# read totals
while IFS="" read -r line || [ -n "$line" ]
do
	read -r total name <<< "$line"
	stars["$name"]=$total
done < "data/$1"

printf '<div align="center">\n\n'

echo "|Current|Previous|Repository|Stars|"
echo "|:---:|:---:|:---|:---:|"
#draw chart
while IFS="" read -r line || [ -n "$line" ]
do
	read -r position name <<< "$line"
	last=${yesterday["$name"]}
	star=${diffs["$name"]}
    total=${stars["$name"]}
    desc="$(curl -s "https://api.github.com/repos/$name"  --header "Authorization: Bearer $PAT" | jq -r .description)"
    
    # move=""
    # if ((position < last))
    # then
    #     move="🔼"
    # elif ((position > last))
    # then
    #     move="🔽"
    # else
    #     move="  "
    # fi
    echo "|$position|${last:--}|[https://github.com/$name]($name)<br/>$desc|$total <sup>(+$star)</sup>|"
done < "today-nr"

printf '\n\n<div>\n'



