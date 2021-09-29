defmodule ApiTest do
  use ExUnit.Case

  import Exkismet

  test "verify" do
    assert verify(key: key(), blog: "http://127.0.0.1")
  end

  test "submit_spam" do
    assert submit_spam(spam_comment(), key: key()) == :ok
  end

  test "submit_ham" do
    assert submit_spam(spam_comment(), key: key()) == :ok
  end

  test "check spam comment" do
    assert comment_check(spam_comment(), key: key(), request_user_agent: "Exkismet Testing Tool") ==
             :spam
  end

  test "check normal comment" do
    assert comment_check(normal_comment(), key: key()) == :ham
  end

  defp normal_comment,
    do: %Exkismet.Comment{
      spam_comment()
      | user_role: :administrator,
        comment_author: "Someone",
        comment_author_email: "Somewhere"
    }

  defp spam_comment do
    %Exkismet.Comment{
      blog: "http://127.0.0.1",
      is_test: true,
      blog_charset: "UTF-8",
      comment_post_modified_gmt: "2015-12-30T10:40:10.047-0500",
      comment_date_gmt: "2015-12-30T10:41:28.448-0500",
      comment_content: "I like big butz and you can too.",
      comment_author_url: "www.mrspam.com",
      comment_author_email: "akismet-guaranteed-spam@example.com",
      comment_author: "viagra-test-123",
      comment_type: :comment,
      permalink: "http://127.0.0.1/my_big_post",
      referrer: "http://google.com",
      user_agent:
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36",
      user_ip: "192.168.0.5"
    }
  end

  defp key do
    System.get_env("AKISMET_KEY")
  end
end
