json.data do
  json.array! @posts, partial: "api/v1/posts/post", as: :post
end

json.meta do 
  json.current_page @pagy.page
  json.next_page @pagy.next
  json.prev_page @pagy.prev
  json.total_pages @pagy.pages
  json.total_count @pagy.count
end