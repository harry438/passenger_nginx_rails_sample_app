json.extract! admin_book, :id, :title, :author, :created_at, :updated_at
json.url admin_book_url(admin_book, format: :json)