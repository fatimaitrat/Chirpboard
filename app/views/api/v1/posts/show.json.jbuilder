json.message "Post created successfully"
json.data do
  json.partial! "api/v1/posts/post", post: @post
end