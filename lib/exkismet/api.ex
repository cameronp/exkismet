defmodule Exkismet.Api do
  @moduledoc """
  Provides a simple method for calling the Akismet API.  To use, be sure to set
  your hostname, and api key by adding the following line in config.exs:

  `config :exkismet, key: "<your api key>", blog: "http://yourhostname.com"`
  """


  @doc """
  Validates your API key with akismet.com.  If this fails, it's probably because
  you haven't set your API key in config.exs, like so:

  `config :exkismet, key: "<your api key>", blog: "http://yourhostname.com" `
  """
  def verify do
    case Exkismet.Service.verify do
      %{body: "valid"} -> :valid
      error -> {:invalid, error}
    end
  end


  @doc """
  Checks a comment with Akismet.  Takes a map of meta data about the comment,
  using the following keys:
  ```
  is_test: <true> if you're testing, leave it out otherwise  Keeps Akismet from
    using this message for training,
  ```

  These attributes are required.
  ```
  blog: "http://<yourhostname>.com",
  user_agent: the user agent of the *commenter*
  user_ip: the ip of the commenter
  ```
  The following are optional, but the more you have the better it works.
  ```
  referrer: "http://google.com",

  blog_charset: "UTF-8", // character set of the comment

  comment_post_modified_gmt: "2015-12-30T10:40:10.047-0500", time that the blogpost
    was updated in UTC, ISO8601 format.

  comment_date_gmt: "2015-12-30T10:41:28.448-0500", time the comment was created
    in UTC, ISO8601 format

  comment_content: <the comment itself>,
  comment_author_url: <the authors URL>,
  comment_author_email: "bigboss@mrspam.com",
  comment_author: "viagra-test-123",
  comment_type: "comment", (other types include tracbacks, etc)
  permalink: "http://127.0.0.1/my_blog_post",
  ```
  """
  def comment_check(comment) when is_map(comment) do
    case Exkismet.Service.comment_check(comment) do
      %{headers: %{"X-akismet-pro-tip" => "discard"}} -> :discard
      %{body: "true"} -> :spam
      %{body: "false"} -> :ham
      error -> {:error, error}
    end
  end

  @doc """
  Report a comment as being spam.  Uses the same fields as described in
  Exkismet.Api.comment_check
  """
  def submit_spam(comment) when is_map(comment) do
    case Exkismet.Service.submit_spam(comment) do
      %{body: "Thanks" <> _} -> :ok
      error -> {:error, error}
    end
  end

  @doc """
  Report a comment as being ham (not spam).  Uses the same fields as described in
  Exkismet.Api.comment_check
  """
  def submit_ham(comment) when is_map(comment) do
    case Exkismet.Service.submit_ham do
      %{body: "Thanks" <> _} -> :ok
      error -> {:error, error}
    end
  end
end
