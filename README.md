# ContrastWeb

Simple site written in Swift that shows the contrast of two colors using the [Color](https://github.com/soffes/Color) package.

## Deploying

This site is deployed to Google Cloud Platform. This [setup guide](https://cloud.google.com/kubernetes-engine/docs/tutorials/hello-app) was really helpful. Here are the relevant bits for deploying a new version.

### Build a new image

Be sure to increment the version in this command:

```
$ docker build -t gcr.io/usecontrast/contrast-web:v2 .
```

### Test the new image

This will start the server locally at [localhost:8080](http://localhost:8080). Be sure to update the version in the image name.

```
$ docker run --rm -p 8080:8080 gcr.io/usecontrast/contrast-web:v2
```

(To stop this, run `docker ps` in a new tab and note the container ID of the most recent one. Then run `docker stop CONTAINER_ID`.)

### Deploy the image

Be sure to update the version number in the image name.

```
$ docker push gcr.io/usecontrast/contrast-web:v2
$ kubectl set image deployment/contrast-web usecontrast-web=gcr.io/usecontrast/contrast-web:v2
```
