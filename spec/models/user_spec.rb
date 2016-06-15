require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it { is_expected.to allow_values("a@a.ru", "string@a.ru","a@#{'a'*25}.ru").for(:email) }

  it { is_expected.to_not allow_values("", "a@a.u", "string@", "@string","a@#{'a'*29}", user.email, user.email.upcase).for(:email) }


  it { is_expected.to allow_values("aaa", "a"*30).for(:first_name) }

  it { is_expected.to_not allow_values("", "aa", "a"*31).for(:first_name) }


  it { is_expected.to allow_values("aaa", "a"*30).for(:last_name) }

  it { is_expected.to_not allow_values("", "aa", "a"*31).for(:last_name) }


  it { is_expected.to allow_values("a"*6, "a"*20).for(:password) }

  it { is_expected.to_not allow_values("", "a"*5, "a"*21).for(:password) }
end
