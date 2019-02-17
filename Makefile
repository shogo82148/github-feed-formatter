build: formatter.zip
formatter.zip: psgi.pl cpanfile formatter.psgi
	docker run --rm -v $(PWD):/var/task shogo82148/p5-aws-lambda:build-5.28 \
		cpanm --notest -L extlocal --installdeps .
	zip -r formatter.zip . -x '*.zip' -x '.*' -x 'local/'

clean:
	rm -f formatter.zip
	rm -rf local
	rm -rf extlocal

package:
	sam package \
		--output-template-file packaged.yml \
		--s3-bucket shogo82148-sam

deploy: package
	sam deploy \
		--stack-name github-feed-formatter \
		--template packaged.yml \
		--region us-east-1 \
		--capabilities CAPABILITY_IAM

.PHONY: build clean package deploy
