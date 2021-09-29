defmodule Exkismet.Comment do
  @moduledoc """
  Structure to represent a comment that is going to be sent to Akismet.

  These attributes are required.
  * `blog`: The front page or home URL of the instance making the request. For a blog or wiki this would be the front page. Note: Must be a full URI, including http://.
  * `user_ip`:  IP address of the comment submitter.

  The following are optional, but the more you have the better it works.
  * `user_agent`: User agent string of the web browser submitting the comment. Not to be confused with the user agent of your Akismet library.
  * `referrer`: the referrer, such as `"http://google.com"`
  * `blog_charset`: The character encoding for the form values included in comment_* parameters, such as `"UTF-8"` or `"ISO-8859-1"`. Defaults to `"UTF-8"`
  * `blog_lang`: Indicates the language(s) in use on the blog or site, in [ISO 639-1](https://en.wikipedia.org/wiki/ISO_639-1) format, comma-separated. A site with articles in English and French might use `"en, fr_ca"`.
  * `comment_post_modified_gmt`: time that the blogpost was updated in UTC, [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format.
  * `comment_date_gmt`: The UTC timestamp of the creation of the comment, in [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format. May be omitted for comment-check requests if the comment is sent to the API at the time it is created.
  * `comment_content`: The content that was submitted.
  * `comment_author_url`: URL submitted with comment. Only send a URL that was manually entered by the user, not an automatically generated URL like the user’s profile URL on your site.
  * `comment_author_email`: the author's email, such as `"bigboss@mrspam.com"`,
  * `comment_author`: the author's username, such as `"viagra-test-123"`,
  * `comment_type`: describes the type of content being sent. Defaults to `:comment`. Typical values are:
    * `"comment"`: A blog comment.
    * `"forum-post"`: A top-level forum post.
    * `"reply"`: A reply to a top-level forum post.
    * `"blog-post"`: A blog post.
    * `"contact-form"`: A contact form or feedback form submission.
    * `"signup"`: A new user account.
    * `"message"`: A message sent between just a few users.

    You may send a value not listed above if none of them accurately describe your content. This is further explained [here](http://blog.akismet.com/2012/06/19/pro-tip-tell-us-your-comment_type/).
  * `permalink`: The full permanent URL of the entry the comment was submitted to.
  * `user_role`: The user role of the user who submitted the comment. This is an optional parameter. If you set it to “administrator”, Exkismet will always return `:ham`.
  * `is_test`: `true` if you're testing. Keeps Akismet from using this message for training. Defaults to `false`.
  * `recheck_reason`:  If you are sending content to Akismet to be rechecked, such as a post that has been edited or old pending comments that you’d like to recheck, include the parameter `recheck_reason` with a string describing why the content is being rechecked. For example, `recheck_reason=edit`.
  """

  @type t :: %Exkismet.Comment{
          is_test: boolean(),
          blog: String.t(),
          blog_lang: String.t() | nil,
          user_agent: String.t() | nil,
          user_ip: String.t(),
          referrer: String.t() | nil,
          blog_charset: String.t() | nil,
          comment_post_modified_gmt: String.t() | nil,
          comment_date_gmt: String.t() | nil,
          comment_content: String.t() | nil,
          comment_author_url: String.t() | nil,
          comment_author_email: String.t() | nil,
          comment_author: String.t() | nil,
          comment_type: String.t(),
          permalink: String.t() | nil,
          user_role: :administrator | nil,
          honeypot_field_name: String.t(),
          recheck_reason: String.t()
        }

  @enforce_keys [:blog, :user_ip]
  defstruct [
    :blog,
    :blog_lang,
    :user_role,
    :recheck_reason,
    :honeypot_field_name,
    :user_agent,
    :user_ip,
    :referrer,
    :comment_post_modified_gmt,
    :comment_date_gmt,
    :comment_content,
    :comment_author_url,
    :comment_author_email,
    :comment_author,
    :permalink,
    comment_type: "comment",
    blog_charset: "UTF-8",
    is_test: false
  ]
end
