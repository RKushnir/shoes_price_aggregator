class Notifier < ActionMailer::Base
  default from: "intertop.watcher@gmail.com"

  def prices_change_notification(subscriber, price_changes)
    @price_changes = price_changes

    mail to: subscriber.email
  end
end
