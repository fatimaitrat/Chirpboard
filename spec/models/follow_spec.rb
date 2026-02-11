require 'rails_helper'

RSpec.describe Follow, type: :model do
  let(:follower) { User.create!(username: "follower", email: "f@test.com", password: "password") }
  let(:followed) { User.create!(username: "followed", email: "ed@test.com", password: "password") }

  describe 'validations' do
    context 'when creating a new relationship' do
      it "is valid with a follower and followed" do
        follow = Follow.new(follower: follower, followed: followed)
        expect(follow).to be_valid
      end
    end

    context 'when missing associations' do
      it "is invalid without a follower" do
        follow = Follow.new(follower: nil, followed: followed)
        expect(follow).to_not be_valid
      end

      it "is invalid without a followed user" do
        follow = Follow.new(follower: follower, followed: nil)
        expect(follow).to_not be_valid
      end
    end
    
    context 'when the relationship already exists' do
      before do
        # Create the first relationship
        Follow.create!(follower: follower, followed: followed)
      end

      it "prevents duplicate follows" do
        duplicate_follow = Follow.new(follower: follower, followed: followed)
        expect(duplicate_follow).to_not be_valid
        # This checks that the database uniqueness constraint is working
      end
    end
  end
end