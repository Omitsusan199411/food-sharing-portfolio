class AdminCheckValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless value =~ /\A[ぁ-んァ-ン一-龥]+　{0}[ぁ-んァ-ン一-龥]+\z/
      record.errors[attribute] << "名の全角スペースは姓と名の間に入れてください"
    end
  end
  
end
