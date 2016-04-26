class ApiConstraints
  def initialize(opts)
    @version = opts[:version]
    @default = opts[:default]
  end

  def matches?(request)
    @default ||
      request.headers['Accept'].include?("application/vnd.marketplace.v#{@version}")
  end
end
