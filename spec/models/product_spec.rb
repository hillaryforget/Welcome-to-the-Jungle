require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
    it 'should have a name, price, quantity and category' do
      @category = Category.new(name: 'Plant')
      @product = @category.products.build(name: 'Snake', price: 1000, quantity: 10)
      @product.valid?
      expect(@product.errors.full_messages.size).to eq(0)
    end

    it 'should have a name' do
      @category = Category.new(name: 'Plant')
      @product = @category.products.build(name: 'Snake')
      @product.valid?
      expect(@product.errors[:name].size).to eq(0)
    end

    it 'should have a price' do
      @category = Category.new(name: 'Plant')
      @product = @category.products.build(price: 1000)
      @product.valid?
      expect(@product.errors[:price].size).to eq(0)
    end

    it 'should have a quantity' do
      @category = Category.new(name: 'Plant')
      @product = @category.products.build(quantity: 10)
      @product.valid?
      expect(@product.errors[:quantity].size).to eq(0)
    end

    it 'should have a category' do
      @product = Product.create(name: 'Snake', price: 1000, quantity: 10)
      @product.valid?
      expect(@product.errors.full_messages).to include("Category can't be blank")
    end
  end
end
