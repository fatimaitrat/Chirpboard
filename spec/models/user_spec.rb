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
      #User.create!(username:"original", email: "first@example.com", password: "password")
      create(:user, username: "original")
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
      create(:user, email: "test@example.com", password: "password")
      user2 = User.new(username: "user2", email: "test@example.com", password: "password")
      
      expect(user2).to_not be_valid
      expect(user2.errors[:email]).to include("has already been taken")
    end
  end
  
  #The follow method
  describe '#follow' do
    #we need two users to test following 
    let(:alice) { create(:user, username: "alice") }
    let(:bob) { create(:user, username: "bob") } 

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
    let(:alice) { create(:user, username: "alice") }
    let(:bob) { create(:user,username: "bob") } 

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
      user = create(:user)

      user.posts.create!(body: "Hello world")

      expect { user.destroy }.to change { Post.count }.by(-1)
    end
  end
 


  describe 'secure token' do
    it "generates an auth_token upon creation" do
      user = create(:user)
      expect(user.auth_token).to be_present
    end
  end

  describe ".generate_unique_secure_token" do
    it "regenerates the secure token if the first one is taken" do
      
      #existing_user = instance_double(User)

      allow(SecureRandom).to receive(:hex).and_return("taken_token", "fresh_token")

      allow(User).to receive(:exists?).with(auth_token: "taken_token").and_return(true)

      allow(User).to receive(:exists?).with(auth_token: "fresh_token").and_return(false)

      token = User.generate_unique_secure_token
      expect(token).to eq("fresh_token")
    end

  end

  describe "avatar generation" do
    it "fetches and attracts a default avatar from DiceBear upon creation" do
      fake_image_data = StringIO.new("<svg>...<svg>")

      allow(URI).to receive(:open).and_return(fake_image_data)

      user = User.create!(username: "spy_test", email: "spy@test.com", password: "password")

      expect(URI).to have_received(:open).with(
        "https://api.dicebear.com/7.x/initials/svg?seed=spy_test"
      )

      expect(user.avatar).to be_attached
    end
  end
  describe "manual avatar upload" do
    it "allows a user to attach a custom photo" do
      user = create(:user)

      file_path = Rails.root.join("spec", "fixtures", "files", "default_avatar.svg")

      user.avatar.attach(
        io:File.open(file_path),
        filename: "custom_avatar.svg",
        content_type: "img/svg+xml"
      )

      expect(user.avatar).to be_attached
      expect(user.avatar.filename.to_s).to eq("custom_avatar.svg")
    end
  end
end
