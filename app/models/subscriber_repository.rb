class SubscriberRepository
  class << self
    delegate :find_each, to: Persistent::Subscriber
  end
end
