# typed: true
# frozen_string_literal: true

require_relative 'error'

# Reads and modifies the command history
class History
  extend T::Sig

  attr_reader :items

  HistoryItem = T.type_alias { T.any(T.nilable(String), T::Array[String]) }

  def initialize
    @items = T.let([], T::Array[String])
    @last  = T.let(0, Integer)
    @path  = T.let(File.expand_path('sushi_history'), String)

    load_history
  end

  sig { params(other: String).void }
  def +(other)
    store(other)
  end

  sig { params(nth: Integer).returns(HistoryItem) }
  def get(nth = 0)
    return @items if nth.zero?

    @items[nth - 1]
  end

  sig { params(item: String).void }
  def store(item)
    return if ignorespace(item) || clear_flag?(item)

    numbering = T.let(1, Integer)
    numbering = (last + 1) unless last.nil?

    item = [numbering, item].join(', ')

    @items << item

    File.open(@path, 'a') { |f| f.puts item }
  end

  sig { void }
  def clear
    @items = []

    throw(ErrorType::FileNotFound) unless File.exist? @path

    File.truncate(@path, 0)
  end

  private

  sig { params(item: String).returns(T::Boolean) }
  def ignorespace(item)
    item.start_with?("\s")
  end

  sig { params(item: String).returns(T::Boolean) }
  def clear_flag?(item)
    item.match?(/history\s*\-c/im)
  end

  sig { void }
  def load_history
    T.must(File.open(@path, 'r')).each_line { |item| @items << item }
  end

  sig { returns(T.nilable(Integer)) }
  def last
    previous = T.let(@items[-1], T.nilable(String))

    return nil if previous.nil?

    previous.split(',')[0].to_i
  end
end
