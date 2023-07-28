package main
import data.lib.kubernetes
import data.deployments.whoami as whoami_tpl

service_selects_app(labels) {
  input[i].contents.kind == "Service"
  service := input[i].contents
  service.spec.selector == labels
}

# Deployment has a service
deny[msg] {
  input[i].contents.kind == "Deployment"
  deployment := input[i].contents
  not service_selects_app(deployment.spec.selector.matchLabels)
  msg := sprintf("Deployment '%v' has no matching service", [deployment.metadata.name])
}

# Deployment is w-whoami
deny[msg] {
  input[i].contents.kind == "Deployment"
  deployment := input[i].contents
  name := deployment.metadata.name
  not name == "w-whoami"

  msg := "Deployment name must be named w-whoami"
}

# Deployment has req. labels
deny[msg] {
  input[i].contents.kind == "Deployment"
  deployment := input[i].contents
  labels := deployment.metadata.labels
	not kubernetes.required_deployment_labels(labels)

	msg = sprintf("Deployment %s must include Kubernetes recommended labels", [deployment.metadata.name])
}

# Deployment image check
deny[msg] {
  input[i].contents.kind == "Deployment"
  deployment := input[i].contents
  [image_tpl, image_tag_tpl] := [whoami_tpl.containers.whoami.image, whoami_tpl.containers.whoami.imageTag]
	[image_name, image_tag] = kubernetes.split_image(deployment.spec.template.spec.containers[_].image)
  not [image_tpl, image_tag_tpl] == [image_name, image_tag]

  msg = sprintf("Deployment %s has include wrong image - '%v' != '%v'",
    [deployment.metadata.name,
      concat(":", [image_tpl, image_tag_tpl]),
      concat(":", [image_name, image_tag]),
    ])
}

# Deployment securityContext check
deny[msg] {
  input[i].contents.kind == "Deployment"
  deployment := input[i].contents
  not deployment.spec.template.spec.securityContext == whoami_tpl.securityContext

  msg := sprintf("Deployment '%v' has no matching securityContext: '%v' != '%v'",
    [deployment.metadata.name,
      deployment.spec.template.spec.securityContext,
      whoami_tpl.securityContext])
}


# Deployment ports check
deny[msg] {
  input[i].contents.kind == "Deployment"
  deployment := input[i].contents
  not deployment.spec.template.spec.securityContext == whoami_tpl.securityContext
  ports_tpl := whoami_tpl.containers.whoami.ports
  ports := deployment.spec.template.spec.containers[_].ports
  not ports_tpl == ports

  msg = sprintf("Deployment %s has not match ports - '%v' != '%v'",
    [deployment.metadata.name,
      ports_tpl,
      deployment.spec.template.spec.containers[_].ports,
    ])
}
