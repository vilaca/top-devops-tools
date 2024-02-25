echo Fetching repo info

curl https://raw.githubusercontent.com/vilaca/awesome-k8s-tools/main/data/repos \
    | cut -d '/' -f4-5 \
    | while read repo; do echo "$(curl -s "https://api.github.com/repos/$repo"  --header "Authorization: Bearer $PAT" \
    | jq .stargazers_count) $repo"; done \
    > $(date +"%d-%m-%Y")

