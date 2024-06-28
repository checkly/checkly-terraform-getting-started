terraform {
  required_providers {
    checkly = {
      source  = "checkly/checkly"
      version = "~> 1.0"
    }
  }
}

variable "checkly_api_key" {}
variable "checkly_account_id" {}

provider "checkly" {
  api_key    = var.checkly_api_key
  account_id = var.checkly_account_id
}

resource "checkly_check" "api-check-1" {
  name      = "Example API check"
  type      = "API"
  activated = true
  frequency = 1

  retry_strategy {
    type                 = "FIXED"
    base_backoff_seconds = 60
    max_duration_seconds = 600
    max_retries          = 3
    same_region          = false
  }

  locations = [
    "us-west-1",
    "eu-central-1"
  ]

  group_id = checkly_check_group.group-1.id

  request {
    url              = "https://danube-web.shop/api/books"
    follow_redirects = true
    skip_ssl         = false
    assertion {
      source     = "JSON_BODY"
      property   = "$..title"
      comparison = "NOT_EMPTY"
    }
  }
}

resource "checkly_check" "browser-check-1" {
  name      = "Example browser check"
  type      = "BROWSER"
  activated = true
  frequency = 10

  retry_strategy {
    type                 = "FIXED"
    base_backoff_seconds = 60
    max_duration_seconds = 600
    max_retries          = 3
    same_region          = false
  }

  locations = [
    "us-west-1",
    "eu-central-1"
  ]

  group_id = checkly_check_group.group-1.id

  script = <<EOT
const assert = require("chai").assert;
const { chromium } = require("playwright");

const browser = await chromium.launch();
const page = await browser.newPage();
await page.goto("https://danube-web.shop");
const title = await page.title();

assert.equal(title, "Google");
await browser.close();

EOT
}

resource "checkly_heartbeat" "example-heartbeat" {
  name      = "Example heartbeat check"
  activated = true
  heartbeat {
    period      = 7
    period_unit = "days"
    grace       = 1
    grace_unit  = "days"
  }
  use_global_alert_settings = true
}

resource "checkly_check_group" "group-1" {
  name      = "Example group"
  activated = true
  muted     = false
  tags = [
    "auto"
  ]

  locations = [
    "eu-west-1",
  ]
  concurrency = 3

  alert_channel_subscription {
    channel_id = checkly_alert_channel.email_ac.id
    activated  = true
  }
}

resource "checkly_alert_channel" "email_ac" {
  email {
    address = "john@example.com"
  }
  send_recovery = true
  send_failure  = true
  send_degraded = false
}

# resource "checkly_dashboard" "example-dashboard" {
#   custom_url      = "checkly"
#   custom_domain   = "status.example.com"
#   logo            = "https://www.checklyhq.com/logo.png"
#   header          = "Public dashboard"
#   refresh_rate    = 60
#   paginate        = false
#   pagination_rate = 30
#   hide_tags       = false
# }

# resource "checkly_private_location" "location" {
#   name          = "New Private Location"
#   slug_name     = "new-private-location"
# }

resource "checkly_maintenance_windows" "maintenance-1" {
  name            = "Maintenance Windows"
  starts_at       = "2022-04-24T00:00:00.000Z"
  ends_at         = "2022-04-25T00:00:00.000Z"
  repeat_unit     = "MONTH"
  repeat_ends_at  = "2023-08-24T00:00:00.000Z"
  repeat_interval = 1
  tags = [
    "auto",
  ]
}

resource "checkly_snippet" "example-1" {
  name   = "Example snippet"
  script = "console.log('test');"
}