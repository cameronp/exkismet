defmodule Exkismet do
  @moduledoc """
  The Exkismet module provides a simple method for calling the Akismet API.

  You need to build a `Exkismet.Comment` structure from your data to call the functions.

  ## Shared options

  * `:key`: Your Akismet API key. Required.
  * `:request_user_agent`: The user-agent that will be used to make the request to Akismet. Defaults to `"Exkismet/%version%"`.
  """
  alias Exkismet.Comment

  @doc """
  Validates your API key with akismet.com.

  ## Options

  * `:blog`: The front page or home URL of the instance making the request. Must be a full URI, including `http://…`

  See the ["Shared options"](#module-shared-options) section at the module
  documentation for more options.

  ## Examples

      iex> verify(key: "mykey", blog: "https://mywebsite.com")
      :valid

      iex> verify(key: "invalid-key", blog: "https://mywebsite.com")
      :invalid
  """
  @spec verify([{:key, String.t()}, {:blog, String.t()}, {:request_user_agent, String.t()}]) ::
          :valid | {:invalid, HTTPoison.Response.t()}
  def verify(options) do
    case Exkismet.Service.verify(options) do
      %{body: "valid"} -> :valid
      error -> {:invalid, error}
    end
  end

  @type options :: [{:key, String.t()}, {:request_user_agent, String.t()}]

  @doc """
  Checks a comment with Akismet. Takes a `Exkismet.Comment` entity and the `key: "mykey"` as options.

  ## Options
  See the ["Shared options"](#module-shared-options) section at the module
  documentation for more options.

  ## Examples

      iex> comment_check(%Exkismet.Comment{
              blog: "https://suspicious-website.com",
              user_ip: "1.2.4.5"
           }, key: "mykey")
      :spam

      iex> comment_check(%Exkismet.Comment{
              blog: "https://clean-website.com",
              user_ip: "4.5.6.7"
           }, key: "mykey")
      :ham
  """
  @spec comment_check(Comment.t(), options()) ::
          :ham | :spam | :discard | {:error, HTTPoison.Response.t()}
  def comment_check(%Comment{} = comment, options) do
    %HTTPoison.Response{headers: headers, body: body} =
      response = Exkismet.Service.comment_check(comment, options)

    cond do
      get_header(headers, "X-akismet-pro-tip") == "discard" -> :discard
      body == "true" -> :spam
      body == "false" -> :ham
      true -> {:error, response}
    end
  end

  @doc """
  Report a comment as being spam. Takes a `Exkismet.Comment` entity.

  ## Options
  See the ["Shared options"](#module-shared-options) section at the module
  documentation for more options.

  ## Examples

      iex> submit_spam(%Exkismet.Comment{
              blog: "https://suspicious-website.com",
              user_ip: "1.2.4.5"
           }, key: "mykey")
      :ok
  """
  @spec submit_spam(Comment.t(), options()) :: :ok | {:error, HTTPoison.Response.t()}
  def submit_spam(%Comment{} = comment, options) do
    case Exkismet.Service.submit_spam(comment, options) do
      %HTTPoison.Response{body: "Thanks" <> _} -> :ok
      error -> {:error, error}
    end
  end

  @doc """
  Report a comment as being ham (not spam). Takes a `Exkismet.Comment` entity.

  ## Options
  See the ["Shared options"](#module-shared-options) section at the module
  documentation for more options.

  ## Examples

      iex> submit_ham(%Exkismet.Comment{
              blog: "https://suspicious-website.com",
              user_ip: "1.2.4.5"
           }, key: "mykey")
      :ok
  """
  @spec submit_ham(Comment.t(), options()) :: :ok | {:error, HTTPoison.Response.t()}
  def submit_ham(%Comment{} = comment, options) do
    case Exkismet.Service.submit_ham(comment, options) do
      %HTTPoison.Response{body: "Thanks" <> _} -> :ok
      error -> {:error, error}
    end
  end

  @spec get_header(Enum.t(), String.t()) :: String.t() | nil
  defp get_header(headers, key) do
    key = String.downcase(key)

    case List.keyfind(headers, key, 0) do
      {^key, value} -> String.downcase(value)
      nil -> nil
    end
  end
end
