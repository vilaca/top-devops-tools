current_date=$(date +%s)
yesterday=$((1 * 24 * 60 * 60))
yesterday_ago=$((current_date - yesterday))
yesterday_ago_date=$(date -d "@$yesterday_ago" +%d-%m-%Y)
echo $yesterday_ago_date