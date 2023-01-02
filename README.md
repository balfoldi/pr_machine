Some productivity tool

Installation :
Create .env
Fill it with
`GITHUB_PERSONAL_ACCESS_TOKEN={{your token}}`
`OWNER={{repo's owner}}`

run `$ bundle`

Branch name format :

{{label}}/{{issue number}}_{{branch description}}

Utilisation :

move this folder next to your working repo

run :
`$ BUNDLE_GEMFILE=../pr_machine/Gemfile  bundle exec ruby ../pr_machine/app.rb`
