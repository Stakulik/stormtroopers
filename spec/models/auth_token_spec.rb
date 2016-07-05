require 'rails_helper'

RSpec.describe AuthToken, type: :model do
  let!(:auth_token) { create(:auth_token) }

  it { is_expected.to_not allow_values(nil, "", auth_token.content).for(:content) }

  it "destroys with an user" do
    expect { auth_token.user.destroy }.to change { AuthToken.count }
  end
end
