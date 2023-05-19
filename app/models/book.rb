class Book < ApplicationRecord
  after_create_commit -> {
                        broadcast_prepend_to 'books', partial: 'books/book', locals: { book: self }, target: 'books'
                      }
end
