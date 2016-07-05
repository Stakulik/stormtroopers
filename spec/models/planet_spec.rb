require "rails_helper"

RSpec.describe Planet, type: :model do
  it { is_expected.to allow_values("a", "a"*50).for(:name) }

  it { is_expected.to_not allow_values("", nil).for(:name) }
end
