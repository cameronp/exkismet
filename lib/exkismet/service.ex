defmodule Exkismet.Service do
  @moduledoc false
  
  use HTTPoison.Base

  @akismet_verify_url "https://rest.akismet.com/1.1/"
  @akismet_api_base ".rest.akismet.com/1.1/"


  def verify do
    query = [key: key, blog: blog]
    post!("verify-key", query, headers)
  end


  def comment_check(comment) when is_map(comment) do
    post!("comment-check", comment, headers)
  end

  def submit_spam(comment) when is_map(comment) do
    post!("submit-spam", comment, headers)
  end

  def submit_ham(comment) when is_map(comment) do
    post!("submit-ham", comment, headers)
  end


  defp process_request_body(body), do: body |> URI.encode_query

  defp process_headers(headers), do: headers |> Enum.into(%{})

  defp process_url("verify-key"), do: @akismet_verify_url <> "verify-key"
  defp process_url(endpoint), do: "http://" <> key <> @akismet_api_base <> endpoint

  defp headers do
    %{"Content-Type" => "application/x-www-form-urlencoded"}
  end

  defp key, do: Application.get_env(:exkismet, :key)
  defp blog, do: Application.get_env(:exkismet, :blog)


end
