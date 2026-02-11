require 'rails_helper'

RSpec.describe User, type: :model do

  #Validations
  describe 'validations' do
    # Happy path - everyhthing should work here
    it "is valid with a username and password " do
      user = User.new(username: "testuser", email: "test@example.com", password: "password123")
      expect(user).to be_valid  
    end

    #Testing validation - does it fail when username is missing
    it "is invalid without a username" do
      user = User.new(username: nil, email: "test@example.com", password: "pass")
      expect(user).to_not be_valid
      expect(user.errors[:username]).to include("can't be blank")
    end

    #Testing uniqueness - does it fail if ussername is taken
    it "is invalid with a duplicate username" do
      User.create!(username:"original", email: "first@example.com", password: "password")

      duplicate_user = User.new(username: "original", email: "second@example.com", password: "pass")

      expect(duplicate_user).to_not be_valid
      expect(duplicate_user.errors[:username]).to include("has already been taken")
    end

    it "is invalid without an email" do
      user = User.new(username: "testuser", email: nil, password: "password")
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "is invalid with a duplicate email" do
      User.create!(username: "user1", email: "test@example.com", password: "password")
      user2 = User.new(username: "user2", email: "test@example.com", password: "password")
      
      expect(user2).to_not be_valid
      expect(user2.errors[:email]).to include("has already been taken")
    end
  end
  
  #The follow method
  describe '#follow' do
    #we need two users to test following 
    let(:alice) { User.create!(username: "alice", email: "alice#example.com", password: "pass") }
    let(:bob) { User.create!(username: "bob", email: "bob#example.com", password: "pass") } 

    context "when trying to follow self" do
      it "does not allow following yourself" do

        alice.follow(alice)
        expect(alice.following).to be_empty
      end
    end 

    context "when the user is already following" do
      it "does not duplicate the following" do
        alice.follow(bob)
        alice.follow(bob)#try again
        expect(alice.following.count).to eq(1)
      end
    end

    
  end

  describe '#unfollow' do
    let(:alice) { User.create!(username: "alice", email: "alice#example.com", password: "pass") }
    let(:bob) { User.create!(username: "bob", email: "bob#example.com", password: "pass") } 

    context "when the user is following" do
      it "remove the user from the following list" do
        alice.follow(bob)
        alice.unfollow(bob)
        expect(alice.following).to_not include(bob)
      end
    end
    
  end

  describe 'association' do
    it "destroy dependent posrs when user is deleted" do
      user = User.create!(username: "user", email: "email1@example.com", password:"pass")

      user.posts.create!(body: "Hello world")

      expect { user.destroy }.to change { Post.count }.by(-1)
    end
  end

  describe 'secure token' do
    it "generates an auth_token upon creation" do
      user = User.create!(username: "token_user", email: "token@test.com", password: "password")
      expect(user.auth_token).to be_present


    end
  end
end
