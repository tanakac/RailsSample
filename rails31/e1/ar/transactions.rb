# encoding: utf-8
#---
# Excerpted from "Agile Web Development with Rails, 4th Ed.",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rails4 for more book information.
#
# 日本語版については http://ssl.ohmsha.co.jp/cgi-bin/menu.cgi?ISBN=978-4-274-06866-9
#---
$: << File.dirname(__FILE__)
require "connect"
require "logger"

#ActiveRecord::Base.logger = Logger.new(STDERR)

require "rubygems"
require "active_record"


ActiveRecord::Schema.define do 
  create_table :accounts, force: true do |t|
    t.string  :number
    t.decimal :balance, precision: 10, scale: 2, default: 0
  end
end


class Account < ActiveRecord::Base
  validate :price_must_be_at_least_a_cent

  def self.transfer(from, to, amount)
    transaction(from, to) do
      from.withdraw(amount)
      to.deposit(amount)
    end
  end

  def withdraw(amount)
    adjust_balance_and_save(-amount)
  end

  def deposit(amount)
    adjust_balance_and_save(amount)
  end

  private

  def adjust_balance_and_save(amount)
    self.balance += amount
    save!
  end

  def price_must_be_at_least_a_cent
    errors.add(:balance, "が負の値です") if balance < 0.01
  end
end

  def adjust_balance_and_save(amount)
    self.balance += amount
  end

peter = Account.create(balance: 100, number: "12345")
paul  = Account.create(balance: 200, number: "54321")

case ARGV[0] || "1"

when "1"
  Account.transaction do
    paul.deposit(10)
    peter.withdraw(10)
  end

when "2"
  Account.transaction do
    paul.deposit(350)
    peter.withdraw(350)
  end

when "3"
  begin
    Account.transaction do
      paul.deposit(350)
      peter.withdraw(350)
    end
  rescue
    puts "振り替えが中止されました"
  end
  
  puts "Paulは#{paul.balance}所持しています"
  puts "Peterは#{peter.balance}所持しています"

when "4"
  begin
    Account.transaction(peter, paul) do
      paul.deposit(350)
      peter.withdraw(350)
    end
  rescue
    puts "振り替えが中止されました"
  end
  
  puts "Paulは#{paul.balance}所持しています"
  puts "Peterは#{peter.balance}所持しています"
  
when "5"
  Account.transfer(peter, paul, 350) rescue  puts "振り替えが中止されました"
  
  puts "Paulは#{paul.balance}所持しています"
  puts "Peterは#{peter.balance}所持しています"

end



