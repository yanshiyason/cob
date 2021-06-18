build:
	gem build cob.gemspec

.PHONY: login
login:
	curl -u yanshiyason https://rubygems.org/api/v1/api_key.yaml > ~/.gem/credentials; chmod 0600 ~/.gem/credentials

.PHONY: push
push:
	VERSION=`cat ./lib/version.rb | grep VERSION | sed -n "s/^.*'\(.*\)'.*$$/\1/ p"`; \
	gem push "cob-$$VERSION.gem"


# Note to self: remove bad version
# $ gem yank cob -v 0.1.2