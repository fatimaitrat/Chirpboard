class PostMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.post_mailer.digest.subject
  #
  default from: "noreply@chirpboard.com"
  def digest
    @user = params[:user]
    @posts = Post.where("created_at >= ?", 1.week.ago)
    
    mail(
      to: @user.email,
      subject: "Your weekly Chirpboard Digest"
    )
  end
end
