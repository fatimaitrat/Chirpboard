require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user)}
  

  describe 'validations' do 
    context 'when all attributes are present' do
      it "is valid" do
        post = user.posts.new(body: "Hello world")
        expect(post).to be_valid
      end
    end

    context "when the body is missing" do
      it "is invalid" do
        post = user.posts.new(body: nil)
        expect(post).to_not be_valid
        expect(post.errors[:body]).to include("can't be blank")
      end
    end
    context "when the user is missing" do
      it "is invalid" do
        post = Post.new(body: "Orphan post", user: nil)
        expect(post).to_not be_valid
        expect(post.errors[:user]).to include("must exist")
      end
    end

    context "when the body length is longer than 280" do
      it "is invalid if body is longer than 280 characters" do
        long_body = "a" * 281
        post = user.posts.new(body: long_body)
        expect(post).to_not be_valid
        expect(post.errors[:body]).to include("is too long (maximum is 280 characters)")
      end
    end

  end

  describe 'scopes' do
    it "returns posts in descending error(newest first)" do
      old_post = user.posts.create(body: "Old", created_at: 1.day.ago)
      new_post = user.posts.create!(body: "New", created_at: 1.hour.ago)

      expect(Post.descending).to eq([new_post, old_post])
    end
  end
end
