# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create Post
post = Post.create(title: 'New Post', body: 'This is a new post')

# Create top level comments
25.times do |i|
  comment = Comment.create(body: "This is #{i + 1} comment", post: post)
  # Create replies(second level) for top level comments
  5.times do
    reply = Comment.create(body: "This is reply of Comment #{comment.id}", post: post, parent: comment)
    # Create replies for second level comments
    3.times do
      Comment.create(body: "This is reply of Comment #{reply.id}", post: post, parent: reply)
    end
  end
end
