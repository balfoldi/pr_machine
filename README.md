Some productivity tool

Test :
$ git checkout -b test-4| touch test3 | git add . | git commit -m "test" | git push --set-upstream origin test-4

Utilisation :

$ BUNDLE_GEMFILE=../pr_machine/Gemfile  bundle exec ruby ../pr_machine/app.rb
