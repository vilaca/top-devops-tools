current_date=$(date +%s)
seven_days=$((7 * 24 * 60 * 60))
seven_days_ago=$((current_date - seven_days))
seven_days_ago_date=$(date -d "@$seven_days_ago" +%d-%m-%Y)
echo $seven_days_ago_date