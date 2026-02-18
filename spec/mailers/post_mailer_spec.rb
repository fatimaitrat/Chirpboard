require "rails_helper"

RSpec.describe PostMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user, email: "reader@example.com") }
    let!(:recent_post) { create(:post, body: "Breaking News Update", created_at: 1.hour.ago) }
    let!(:old_post) { create(:post, body: "Old News Archive", created_at: 2.weeks.ago)  }


    let(:mail) { PostMailer.with(user: user).digest }

    it "renders the headers" do
      expect(mail.subject).to eq("Your weekly Chirpboard Digest")
      expect(mail.to).to eq(["reader@example.com"])
      expect(mail.from).to eq(["noreply@chirpboard.com"])
    end

    it "renders the body within recent posts only" do
      body = mail.body.encoded

      expect(body).to match("Hello, #{user.username}")
      expect(body).to match("Breaking News Update")

      expect(body).to_not match("Old News Archive")
      
    end
  end

end
