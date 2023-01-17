Summary:
Script to extract from a zip and upload the contents to a new repo in git.
Need to set either a personal or organization account to target. An organizational account 
will take precedence over a personal account. Git has different API endpoints depending on 
if using an Org or User endpoint

Requirements:
need to have an API token for git
 - on a logged in github page open user -> settings
 - bottom left click "developer settings"
 - click "personal access tokens" -> Tokens (classic)
 - generate new token (classic)
 - scope is "repo"
 - generate token

add the token to secured_items.txt 


