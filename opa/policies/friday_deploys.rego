package terraform.policies.friday_deploys

deny[msg] {
  time.weekday(time.now_ns()) == "Sunday"

  msg := "No deployments allowed Today"

}
