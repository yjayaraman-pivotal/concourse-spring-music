#Spring music on concourse

![](images/pipeline.png)

* [Concourse](http://councourse.ci)
* Build only once
* Every build is a release candidate
* Every build step runs inside a docker container mounting to garden linux cells

## Resources

* music-repo E.g. git@github.com:datianshi/spring-music.git

* version (Application/spring music version): A file to track the version stored in s3. Content with E.g. 1.0.1

* music-release A bucket in s3 that stores spring-music artifact E.g. spring-music-1.0.1.war

## Pipeline progress

### Check out from the music-repo

### Unit testing spring-music

This step runs on a container with gradle and java installed.
Basically it just run "gradle test" against the music-repo

### Build Binary

* music-repo - Check out the same source version of music-repo as unit step
* version - Checkout the version file from s3
* "gradle assemble" generates the war artifact
* Push the artifact to the s3 resource as music-resource
* Git tag on the music-repo
* Bump the version resource for next usage

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
