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

    context 'タスクの終了期限が空の場合' do
      it 'バリデーションに失敗する' do
        task = FactoryBot.build(:task, deadline_on: nil)
        expect(task).not_to be_valid
      end
    end

    context 'タスクの優先度が空の場合' do
      it 'バリデーションに失敗する' do
        task = FactoryBot.build(:task, priority: nil)
        expect(task).not_to be_valid
      end
    end

    context 'タスクのステータスが空の場合' do
      it 'バリデーションに失敗する' do
        task = FactoryBot.build(:task, status: nil)
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

  describe '検索機能' do
    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      let!(:first_task) { FactoryBot.create(:task, title: 'aaa_task', status: "not_started") }
      let!(:second_task) { FactoryBot.create(:task, title: 'bbb_task', status: "in_progress") }
      let!(:third_task) { FactoryBot.create(:task, title: 'aaa_bbb_task', status: "completed") }

      it "検索ワードを含むタスクが絞り込まれる" do
        result = Task.fuzzy_search("aaa")
        expect(result).to include(first_task, third_task)
        expect(result).not_to include(second_task)
        expect(result.length).to eq 2
      end
    end

    context 'scopeメソッドでステータス検索をした場合' do
      let!(:first_task) { FactoryBot.create(:task, title: 'aaa_task', status: "not_started") }
      let!(:second_task) { FactoryBot.create(:task, title: 'bbb_task', status: "in_progress") }
      let!(:third_task) { FactoryBot.create(:task, title: 'aaa_bbb_task', status: "completed") }

      it "ステータスに完全一致するタスクが絞り込まれる" do
        result = Task.in_status("in_progress")
        expect(result).to include(second_task)
        expect(result).not_to include(first_task, third_task)
        expect(result.length).to eq 1
      end
    end

    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      let!(:first_task) { FactoryBot.create(:task, title: 'aaa_task', status: "not_started") }
      let!(:second_task) { FactoryBot.create(:task, title: 'bbb_task', status: "in_progress") }
      let!(:third_task) { FactoryBot.create(:task, title: 'aaa_bbb_task', status: "completed") }
      let!(:forth_task) { FactoryBot.create(:task, title: 'aaa_bbb_ccc_task', status: "in_progress") }

      it "検索ワードをタイトルに含み、かつステータスに完全一致するタスクが絞り込まれる" do
        result = Task.in_status("in_progress").fuzzy_search("aaa")
        expect(result).to include(forth_task)
        expect(result).not_to include(first_task, second_task, third_task)
        expect(result.length).to eq 1
      end
    end
  end
end
