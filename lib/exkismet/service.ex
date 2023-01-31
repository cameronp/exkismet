defmodule Exkismet.Service do
  @moduledoc false

  use HTTPoison.Base
  alias Exkismet.Comment

  @akismet_verify_url "https://rest.akismet.com/1.1/"
  @akismet_api_base ".rest.akismet.com/1.1/"

  @spec verify(key: String.t(), blog: String.t(), request_user_agent: String.t()) ::
          HTTPoison.Response.t()
  def verify([key: key, blog: blog] = query) when is_binary(key) and is_binary(blog) do
    simple_query = Keyword.delete(query, :request_user_agent)

    do_post("verify-key", simple_query,
      request_user_agent: Keyword.get(query, :request_user_agent)
    )
  end

  @spec comment_check(comment :: Comment.t(), options :: Exkismet.options()) ::
          HTTPoison.Response.t()
  def comment_check(%Comment{} = comment, options) do
    do_post("comment-check", comment, options)
  end

  @spec submit_spam(comment :: Comment.t(), options :: Exkismet.options()) ::
          HTTPoison.Response.t()
  def submit_spam(%Comment{} = comment, options) do
    do_post("submit-spam", comment, options)
  end

  @spec submit_ham(comment :: Comment.t(), options :: Exkismet.options()) ::
          HTTPoison.Response.t()
  def submit_ham(%Comment{} = comment, options) do
    do_post("submit-ham", comment, options)
  end

  def process_request_body(body) when is_struct(body),
    do: body |> Map.from_struct() |> process_request_body()

  def process_request_body(body), do: body |> URI.encode_query()

  @spec do_post(String.t(), any(), Exkismet.options()) :: HTTPoison.Response.t()
  defp do_post("verify-key", data, options) do
    post!(@akismet_verify_url <> "verify-key", data, headers(options))
  end

  defp do_post(action, data, options) do
    post!(
      "http://" <> Keyword.fetch!(options, :key) <> @akismet_api_base <> action,
      data,
      headers(options)
    )
  end

  @spec headers(Keyword.t()) :: map()
  defp headers(options) do
    %{"Content-Type" => "application/x-www-form-urlencoded", "User-Agent" => user_agent(options)}
  end

  @spec user_agent(Keyword.t()) :: String.t()
  defp user_agent(options) do
    Keyword.get(
      options,
      :request_user_agent,
      "Exkismet/#{Application.spec(:exkismet, :vsn) |> to_string()}"
    )
  end
end
