locals {
  app_name = "demo-webapp"

  # Add / remove users here. Keys must match Helm podLabels.user.
  users = {
    "user1" = {
      email        = "user1@example.com"
      port         = 80
      domain       = "app.user1.example.com"
      extra_emails = []
    }
    # "user2" = {
    #   email        = "user2@example.com"
    #   port         = 80
    #   domain       = "app.user2.example.com"
    #   extra_emails = ["delegate@example.com"]
    # }
  }

  user_iap_members = flatten([
    for key, user in local.users : [
      for email in concat([user.email], user.extra_emails) : {
        user_key = key
        email    = email
      }
    ]
  ])
}
