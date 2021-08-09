require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    # Factory_botメソッドでuserインスタンスを作成。(FactoryBotクラスは省略)
    @user = build(:user)
  end

  describe 'バリデーション' do
    it 'nicknameとemailどちらも値が設定されていればOK' do
      expect(@user.valid?).to eq(true)
    end

    it 'nameが空だとNG' do
      @user.nickname = ''
      expect(@user.valid?).to eq(false)
    end


    it 'emailが空だとNG' do
      @user.email = ''
      expect(@user.valid?).to eq(false)
    end
  end
end

