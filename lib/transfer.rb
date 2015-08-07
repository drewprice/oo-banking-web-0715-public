class Transfer
  attr_reader :sender, :receiver, :amount
  attr_accessor :status

  def initialize(sender, receiver, amount)
    @sender = sender
    @receiver = receiver
    @status = 'pending'
    @amount = amount
  end

  def both_valid?
    sender.valid? && receiver.valid?
  end

  def execute_transaction
    return rejected unless both_valid? && amount_valid?

    tranfer_funds unless status == 'complete'
  end

  def reverse_transfer
    untransfer_funds if status == 'complete'
  end

  private

  def amount_valid?
    sender.balance > amount
  end

  def tranfer_funds
    sender.deposit(0 - amount)
    receiver.deposit(amount)

    self.status = 'complete'
  end

  def untransfer_funds
    receiver.deposit(0 - amount)
    sender.deposit(amount)

    self.status = 'reversed'
  end

  def rejected
    self.status = 'rejected'
    'Transaction rejected. Please check your account balance.'
  end
end
