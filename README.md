# Acuna

* [GitHub](https://github.com/mpimedia/acuna)

## References

* [Rails Guides (8.0.0)](https://guides.rubyonrails.org/v8.0.0/index.html)
* [PostgreSQL](https://www.postgresql.org/docs/)
* [Heroku Documentation](https://devcenter.heroku.com/categories/reference)
* [AWS Documentation](https://docs.aws.amazon.com/)
* [Bootstrap Docs (5.3.3)](https://getbootstrap.com/docs/5.3/getting-started/introduction/)
* [Yarn Docs (2+)](https://yarnpkg.com/getting-started)

## Useful Commands

* Lock Bundle: `bundle lock --add-platform x86_64-linux`

## Tools Versions

### Install asdf for dependency versioning

* [asdf](https://github.com/asdf-vm/asdf)
* Install with `brew install asdf`

### Install Plugins

* ruby: `asdf plugin-add ruby`
* nodejs: `asdf plugin-add nodejs`
* postgres: `asdf plugin-add postgres`

### Update Dependencies

* Update all plugins: `asdf plugin update --all`
* List available versions: `asdf list all [plugin]`
* Install latest library: `asdf install [plugin] latest`
* Set global version: `asdf global [plugin] latest`
* Set local version: `asdf local [plugin] latest`

### Setup Yarn 4+

* Delete existing yarn.lock: `rm -rf yarn.lock`
* Create a blank file: `touch yarn.lock`
* Update to the latest yarn version: `yarn set version berry`

### Production

#### Foundation

* [bootstrap](https://getbootstrap.com/)
* [heroku](https://dashboard.heroku.com/pipelines/af2038da-a8c8-4dfd-966d-dd4c9489ed5c)
* [node](https://nodejs.org/en/)
* [postgres](https://www.postgresql.org/)
* [rack](https://github.com/rack/rack)
* [rails](https://rubyonrails.org/)
* [ruby](https://www.ruby-lang.org/en/)
* [yarn](https://yarnpkg.com/)

#### Tools

* [blazer](https://github.com/ankane/pghero)
* [good_job](https://github.com/bensheldon/good_job)
* [pghero](https://github.com/ankane/pghero)
* [pretender](https://github.com/ankane/pretender)
* [renovate](https://developer.mend.io/github/mpimedia/acuna)
* [simple_form](https://github.com/heartcombo/simple_form)

## Encrypted Credentials

* run `rails credentials:edit`
* Your editor will need to run with --wait due to decryption speed
* example: `export EDITOR="code -w"`
* Retrieve keys with `Rails.application.credentials.[environment_name].[key_name]`
* example `Rails.application.credentials.development.postmark_api_token`

## Database Management

### Heroku Commands

* `heroku run rails db:reset -r [staging|production]` # warning: destructive
* `heroku run rails db:migrate -r [staging|production]`
* `heroku run rails db:seed -r [staging|production]`

### pghero

* [pghero gem](https://github.com/ankane/pghero)
* Update stats with `rake pghero:capture_query_stats`

### blazer

* [blazer gem](https://github.com/ankane/pghero)

## Running Application Locally

### Local Server Commands

* alias foreb="foreman start -f Procfile.dev.backend"
* alias foref="foreman start -f Procfile.dev.frontend"
* alias rs="rails s"

* `foreb` runs good_job worker
* `foref` runs a js and css watcher for changes
* `rs8` runs puma locally on port 8000

## Setup Cloudflare Tunnel

### Setup References

* [Cloudflare Tunnels](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/)

### Setup Steps

* acuna uses the `acuna-dev.mpimediagroup.com` domain for local tunneling with Cloudflare and the `cloudflared` ci
* Install (on Mac) with `brew install cloudflared`
* Login with `cloudflared tunnel login`
* Create name tunnel `cloudflared tunnel create <NAME>` or `cloudflared tunnel create mpivid`
* Create config file at `/User/[username]/.cloudflared/config.yaml`
* [Acuna Cloudflare Tunnel Dashboard](https://one.dash.cloudflare.com/ee0a8e28862d5c84754bbed265f0f861/networks/tunnels?search=)
* Note: Config for the mpimediagroup.com domain is managed on the Cloudflared Tunnel Dashboard

### Running Tunnel Commands

* Run tunnel with `cloudflared tunnel run mpivid`
* Setup alias `alias mpivid="cloudflared tunnel run mpivid"`
* Check tunnel status with `cloudflared tunnel info mpivid`

## Security Checks

* run `bundle outdated` > update gems with `bundle update` > run tests
* run `bundle-audit update`
* run `bundle-audit`
* run `brakeman`

## Security References

* [Ruby Security Discource](https://discuss.rubyonrails.org/c/security-announcements/9)
* [CVE Details](https://www.cvedetails.com/)
* [Security Alerts on GitHub](https://github.blog/news-insights/product-news/introducing-security-alerts-on-github/)

## Asset Pipeline

* propshaft
* js_bundling_rails
* css_bundling_rails
* esbuild
* bootstrap
* sass

## Hotwire

* stimulus
* turbo

## Authentication

* Devise
* Pundit
* System Permissions

## Database

* Postgres
* [pghero](https://github.com/ankane/pghero)
* blazer

## Testing

* rspec
* capybara

## Linting

* rubocop

## Async

* GoodJob

## Notifications

* Noticed
* Topics/Subs

## Views

* ViewComponent

## Assets

* AWS
* cloudfront or cloudflare

## API

* inbound_requests_controller
