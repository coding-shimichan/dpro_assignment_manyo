require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        task = FactoryBot.build(:task, title: nil)
        expect(task).not_to be_valid
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = FactoryBot.build(:task, content: nil)
        expect(task).not_to be_valid
      end
    end

    context 'タスクの属性全てに値が入っている場合' do
      it 'タスクを登録できる' do
        task = FactoryBot.build(:task)
        expect(task).to be_valid
      end
    end
  end
end
