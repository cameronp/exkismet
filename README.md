# Exkismet

Exkismet is a simple Elixir client for the Akismet.com spam detection API.  

## Installation

The package can be installed by adding exkismet to your list of dependencies in `mix.exs`:

```elixir
  def deps do
    [{:exkismet, "~> 0.0.3"}]
  end
```

## Test
```elixir
iex(1)> Exkismet.Api.verify(key: "mykey")
:valid
```
## Checking for spam
```elixir
Exkismet.comment_check(%Exkismet.Comment{…}, key: "mykey")
```
  returns `:ham`, if the comment appears to be ok, `:spam` if it's suspicious, and
  `:discard` if Akismet is 100% certain that it's looking at spam.

## Reporting spam
```elixir
Exkismet.Api.submit_spam(%Exkismet.Comment{…}, key: "mykey")
```
## Reporting ham (non-spam)
```elixir
Exkismet.Api.submit_ham(%Exkismet.Comment{…}, key: "mykey")
```
