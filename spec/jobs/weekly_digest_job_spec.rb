require 'rails_helper'

RSpec.describe WeeklyDigestJob, type: :job do
  
  describe "#perform" do
    let!(:user_1) { create(:user) }
    let!(:user_2) { create(:user) }

    it "send a digest email to every user" do
      mail_delivery = instance_double(ActionMailer::MessageDelivery)
      allow(mail_delivery).to receive(:deliver_later)
      allow(PostMailer).to receive_message_chain(:with, :digest).and_return(mail_delivery)

      WeeklyDigestJob.perform_now

      expect(PostMailer).to have_received(:with).with(user: user_1)
      expect(PostMailer).to have_received(:with).with(user: user_2)

      expect(mail_delivery).to have_received(:deliver_later).twice


    end
  end
end
