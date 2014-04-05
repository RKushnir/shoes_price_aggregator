RSpec::Matchers.define :appear_before do |later_content|
  match do |earlier_content|
    rendered.index(earlier_content) < rendered.index(later_content)
  end
end
