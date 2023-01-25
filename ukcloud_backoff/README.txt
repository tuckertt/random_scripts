Summary:
Script to extract from a zip and upload the contents to a new repo in git.
Need to set either a personal or organization account to target. An organizational account 
will take precedence over a personal account. Git has different API endpoints depending on 
if using an Org or User endpoint

Requirements:

File has to include "-master" in branch name as is for master branch of repo's

need to have an API token for git
 - on a logged in github page open user -> settings
 - bottom left click "developer settings"
 - click "personal access tokens" -> Tokens (classic)
 - generate new token (classic)
 - scope is "repo"
 - generate token

add the token to secured_items.txt 


To Do:
Amend .gitignore to ignore log / contents of the processing folder jic


Github has a rate limit which this script can happily hit. In order to find out how long you have still to cool down:

curl -i -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user

https://support.snyk.io/hc/en-us/articles/360019183838-How-to-test-Github-Rate-limiting

or use cooldown_time.sh
https://docs.github.com/en/rest/overview/resources-in-the-rest-api?apiVersion=2022-11-28#rate-limiting
