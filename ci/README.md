#Spring music on concourse

![](images/pipeline.png)

* [Concourse](http://councourse.ci)
* Build only once and deploy anywhere
* Every build is a release candidate
* Every build step runs inside a docker container mounting to garden linux cells

## Resources

Resources in concourse are implemented as docker images which contain implementations corresponding their types

* music-repo ([git-resource](https://github.com/concourse/git-resource)): A github repo. E.g. spring music github resource

* version ([semver-resource](https://github.com/concourse/semver-resource)): A file to track the version stored in s3. E.g. 1.0.1 in a file named as current-version

* music-release (([s3-resource](https://github.com/concourse/s3-resource))) A bucket in s3 that stores spring-music artifact E.g. spring-music-1.0.1.war

## Pipeline Progress

### Check out from the music-repo

### Unit testing spring-music

This step runs on a container with gradle and java installed.
Basically it just runs "gradle test" against the music-repo

### Build Binary

* music-repo - Check out the same source version of music-repo as unit step
* version - Checkout the version file from s3
* "gradle assemble" generates the war artifact
* Push the artifact to the s3 resource as music-resource
* Git tag on the music-repo
* Bump the version resource for the next usage

### acceptance-tests

* Pull the binary from music-release
* Deploy to cloudfoundry acceptance tests space
* Run Automation Acceptance Tests suite

### promote-to-uat

* Pull the binary from music-release
* Deploy to cloudfoundry uat space
* Waiting for user acceptance tests

### manual-deploy-to-prod

* Manually trigger the build when the operators are ready
* Pull the binary from music-release
* Deploy to prod

### How to replicate this pipeline in your env

* [ Install a concourse environment and fly cli ](http://concourse.ci/getting-started.html)

* Fork this github repo to your own github account, [ generate the key pair and add the public key to github ](https://help.github.com/articles/generating-ssh-keys/), and save the private key for future usage.

* Prepare a s3 bucket named as music-pipeline-artifacts

* fly command line dance

  * ```fly save-target --api https://example.com --username my-user
--password my-password my-target```
  * ```fly -t my-target configure --config spring-music.yml --var "music_private_key=$(cat PRIVATE_KEY_FOR_GITHUB)" --var s3-access-key-id=YOUR_S3_ACCESS_KEY_ID --var s3-secret-access-key=YOUR_S3_ACCESS_KEY --paused=false spring-music```
  * Configure the cloudfoundry target environment in [spring-music.yml](spring-music.yml)
    E.g.

    ```
    API_ENDPOINT: api.10.65.233.228.xip.io
    USERNAME: admin
    PASSWORD: admin
    ORG: test-org
    SPACE: prod
    HOST: music
    ```
