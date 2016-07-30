module Countir
  class AccountCode
    attr_accessor :id, :account_name, :account_name_en, :phonetic_kana, :phonetic_romaji, :account_type

    def initialize(id:, account_name:, account_name_en:, phonetic_kana:, phonetic_romaji:, account_type:)
      self.id              = id
      self.account_name    = account_name
      self.account_name_en = account_name_en
      self.phonetic_kana   = phonetic_kana
      self.phonetic_romaji = phonetic_romaji
      self.account_type    = account_type
    end

    def self.response_schema(data)
      data.map do |r|
        self.new(
          id:              r["id"],
          account_name:    r["account_name"],
          account_name_en: r["account_name_en"],
          phonetic_kana:   r["phonetic_kana"],
          phonetic_romaji: r["phonetic_romaji"],
          account_type:    r["account_type"]
        )
      end
    end
  end
end
