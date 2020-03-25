class ApplicationQuery
  class << self
    def call(*args)
      instance = new(*args)
      instance.call
    end
  end
end
