package lib.kubernetes

required_deployment_labels (labels) {
	labels["app.kubernetes.io/name"]
	labels["app.kubernetes.io/instance"]
	labels["helm.sh/chart"]
	labels["app.kubernetes.io/managed-by"]
}


split_image(image) = [image, "latest"] {
	not contains(image, ":")
}

split_image(image) = [image_name, tag] {
	[image_name, tag] = split(image, ":")
}
