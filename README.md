[![Build Status](https://travis-ci.org/dwyl/tudo.svg?branch=master)](https://travis-ci.org/dwyl/tudo)

# Tudo

You will need the following environment variables in your path:

```bash
#!/bin/bash

export SECRET_KEY_BASE=<secret_key_base>
export GITHUB_CLIENT_ID=<github_client_id>
export GITHUB_CLIENT_SECRET=<github_client_secret>
export GITHUB_API_KEY=<github_api_key>
export GITHUB_ACCESS_TOKEN=<github_access_token>
```

To start the app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

  NB. if you get errors here, please see if this helps: https://github.com/dwyl/learn-phoenix-framework/issues/53

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
