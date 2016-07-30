module Countir
  class Journal
    attr_accessor :transaction_date, :memo, :entries

    class Entry
      attr_accessor :account_code_id, :debit_or_credit, :price

      def initialize(account_code_id:, debit_or_credit:, price:)
        self.account_code_id = account_code_id
        self.debit_or_credit = debit_or_credit
        self.price           = price
      end

      def to_h
        { account_code_id: self.account_code_id,
          debit_or_credit: self.debit_or_credit,
          price:           self.price,
        }
      end
    end


    def initialize(transaction_date:, memo:)
      self.transaction_date = transaction_date
      self.memo             = memo
      self.entries          = []
    end

    def add_entry(account_code_id:, debit_or_credit:, price:)
      self.entries << Entry.new(
        account_code_id: account_code_id,
        debit_or_credit: debit_or_credit,
        price:           price
      )
    end

    def validation!
      unless self.valid?
        raise
      end
    end

    def valid?
      debit_price  = 0
      credit_price = 0

      self.entries.each do |entry|
        debit_price  += entry.price if entry.debit_or_credit  == "debit"
        credit_price += entry.price if entry.credit_or_credit == "credit"
      end

      debit_price == credit_price
    end

    def to_h
      { transaction_date: self.transaction_date,
        memo:             self.memo,
        entries:          self.entries.map(&:to_h),
      }
    end

    def self.response_schema(data)
      data["journals"].map do |journal_data|
        journal = self.new(
          transaction_date: journal_data["transaction_date"],
          memo:             journal_data["memo"],
        )

        journal_data["entries"].each do |entry|
          journal.add_entry(
            account_code_id: entry["account_code_id"],
            debit_or_credit: entry["debit_or_credit"],
            price:           entry["price"],
          )
        end

        journal
      end
    end

  end
end
