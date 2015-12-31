# Exkismet

Exkismet is a simple Elixir client for the Akismet.com spam detection API.  

## Installation

The package can be installed as:

  1. Add exkismet to your list of dependencies in `mix.exs`:

        def deps do
          [{:exkismet, "~> 0.0.1"}]
        end

  2. Ensure exkismet is started before your application:

        def application do
          [applications: [:exkismet]]
        end

## Configuration

  1. Add the following line to your `config.exs` file:

      config :exkismet, key: "<your api key>", blog: "http://<yourhosturl>"


## Test

   iex -S mix
   iex(1)> Exkismet.Api.verify
   :valid
   iex(2)>

## Checking for spam

  Exkismet.Api.comment_check(%{...})  

  returns :ham, if the comment appears to be ok, :spam if it's suspicious, and
  :discard if Akismet is 100% certain that it's looking at spam.

## Reporting spam

  Exkismet.Api.submit_spam(%{...})


## Reporting ham (non-spam)

  Exkismet.Api.submit_ham(%{...})
