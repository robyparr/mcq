class ApplicationService
  class << self
    def call(*args)
      instance = new(*args)
      instance.call

      instance
    end
  end
end
