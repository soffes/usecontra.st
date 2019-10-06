# ContrastWeb

Simple site written in Swift that shows the contrast of two colors using the [Color](https://github.com/soffes/Color) package.

## Running locally

1. Install Xcode 11
2. Run `swift package generate-xcodeproj`
3. Open ContrastWeb.xcodeproj
4. Select `ContrastWeb` from the dropdown in the top left (not `ContrastWeb-Package`)
5. Click ▶️

Now the site is running at [localhost:8080](http://localhost:8080)

## Deploying

This site is deployed to Google Cloud Run.

### Build a new image

Be sure to increment the version in this command:

``` shell
$ docker build -t gcr.io/usecontrast/contrast-web:v2 .
```

### Test the new image

This will start the server locally at [localhost:8080](http://localhost:8080). Be sure to update the version in the image name.

``` shell
$ docker run -d -p 8080:8080 gcr.io/usecontrast/contrast-web:v2
```

(To stop this, run `docker ps` in a new tab and note the container ID of the most recent one. Then run `docker stop CONTAINER_ID`.)

### Push the image

Be sure to update the version number in the image name.

``` shell
$ docker push gcr.io/usecontrast/contrast-web:v2
```

### Deploy the new image

Be sure to update the version number in the image name.

``` shell
$ gcloud beta run deploy contrast-web --image gcr.io/usecontrast/contrast-web:v2
```
