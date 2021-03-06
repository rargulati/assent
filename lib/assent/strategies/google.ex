defmodule Assent.Strategy.Google do
  @moduledoc """
  Google OAuth 2.0 strategy.

  In the normalized user response a `google_hd` ("Hosted Domain") field is
  included in user parameters and can be used to limit access to users
  belonging to a particular hosted domain.

  ## Usage

      config = [
        client_id: "REPLACE_WITH_CLIENT_ID",
        client_secret: "REPLACE_WITH_CLIENT_SECRET"
      ]
  """
  use Assent.Strategy.OAuth2.Base

  @impl true
  def default_config(_config) do
    [
      site: "https://www.googleapis.com",
      authorize_url: "https://accounts.google.com/o/oauth2/v2/auth",
      token_url: "/oauth2/v4/token",
      user_url: "/oauth2/v3/userinfo",
      authorization_params: [scope: "https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile"],
      auth_method: :client_secret_post
    ]
  end

  @impl true
  def normalize(_config, user) do
    {:ok, %{
      "sub"            => user["sub"],
      "name"           => user["name"],
      "given_name"     => user["given_name"],
      "family_name"    => user["family_name"],
      "picture"        => user["picture"],
      "email"          => user["email"],
      "email_verified" => user["verified_email"],
      "locale"         => user["locale"]
    },
    %{
      "google_hd" => user["hd"]
    }}
  end
end
