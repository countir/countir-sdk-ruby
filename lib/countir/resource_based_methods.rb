module Countir
  module ResourceBasedMethods
    def list_account_codes
      get('/account_codes', resource_class: Countir::AccountCode)
    end

    def list_journals(offset: nil, limit: nil)
      params = {offset: offset, limit: limit}
      get('/journals', params, resource_class: Countir::Journal)
    end

    def post_journal(transaction_date:, memo:, entries:)
      unless entries.class == Array
        message = "entries should must be Array value"
        raise Countir::InvalidParameter.new(message)
      end

      entry_keys = [:account_code_id, :debit_or_credit, :price]

      entries_has_valid_keys = entries.map do |entry|
        entry.keys.sort == entry_keys
      end.all?

      unless entries_has_valid_keys
        message = sprintf("entry should have keys [%s]", entry_keys.join(?,))
        raise Countir::InvalidParameter.new(message)
      end

      params = {
        transaction_date: transaction_date,
        memo: memo,
        # entries: entry_keys.zip(*entries.valies_at(entry_keys)).to_h,
        entries: entries,
        images: [],
      }

      post('/journals', params)
    end
  end
end
