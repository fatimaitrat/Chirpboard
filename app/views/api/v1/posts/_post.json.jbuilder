json.id post.id 
json.body post.body
json.created_at post.created_at
json.time_ago time_ago_in_words(post.created_at) + "ago"

json.user do
  json.id post.user.id
  json.username post.user.username
  json.name post.user.name
end