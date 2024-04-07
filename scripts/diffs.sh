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

echo "# Devops OSS Tools Top 30 Chart"
echo "<sup>Compiled using https://github.com/vilaca/awesome-k8s-tools</sup>"

printf '<div align="center">\n\n'

echo "|<sub>Current</sub>|<sub>Previous</sub>|<sub>Repository</sub>|<sub>Stars</sub>|"
echo "|:---:|:---:|:---|:---:|"
#draw chart
while IFS="" read -r line || [ -n "$line" ]
do
	read -r position name <<< "$line"
	last=${yesterday["$name"]}
	star=${diffs["$name"]}
    total=${stars["$name"]}
    desc="$(curl -s "https://api.github.com/repos/$name"  --header "Authorization: Bearer $PAT" | jq -r .description)"
    
    echo "|$position|${last:--}|[**$name**](https://github.com/$name)<br/>$desc|$total <sup>(+$star)</sup>|"
done < "today-nr"

printf '\n\n</div>\n\n'

echo "<sub>This chart estimates the 30 most popular open-source DevOps tools by tallying the GitHub stars each repository received in the last seven days.</sub>"

