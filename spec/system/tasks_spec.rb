require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe 'グローバルナビゲーション' do
    context '一覧画面に遷移した場合' do
      it 'グローバルナビゲーションが表示される' do
        visit tasks_path
        expect(page).to have_content "Tasks Index"
        expect(page).to have_content "New Task"
      end
    end
  end

  describe 'タスク一覧画面' do
    context '一覧画面に遷移した場合' do
      it '画面タイトルが表示される' do
        visit tasks_path
        expect(page).to have_selector "h1", text: "Tasks Index Page"
      end

      it 'テーブルヘッダーが表示される' do
        visit tasks_path
        expect(page).to have_selector "th", text: "Title"
        expect(page).to have_selector "th", text: "Content"
        expect(page).to have_selector "th", text: "Created_at"
      end

      it 'Show/Edit/Destroyのリンクが表示される' do
        FactoryBot.create(:task)

        visit tasks_path
        expect(page).to have_selector "a", text: "Show", class: "show-task"
        expect(page).to have_selector "a", text: "Edit", class: "edit-task"
        expect(page).to have_selector "a", text: "Destroy", class: "destroy-task"
      end
    end
  end

  describe 'タスク登録画面' do
    context 'タスク登録画面に遷移した場合' do
      it '画面タイトルが表示される' do
        visit new_task_path
        expect(page).to have_selector "h1", text: "New Task Page"
      end

      it 'フォームラベルが表示される' do
        visit new_task_path
        expect(page).to have_selector "label", text: "Title"
        expect(page).to have_selector "label", text: "Content"
      end

      it '登録ボタンが表示される' do
        visit new_task_path
        expect(page).to have_button "Create Task", id: "create-task"
      end

      it '戻るリンクが表示される' do
        visit new_task_path
        expect(page).to have_selector "a", text: "Back", id: "back"
      end
    end
  end
  
  describe 'タスク詳細画面' do
    context 'タスク詳細画面に遷移した場合' do
      it '画面タイトルが表示される' do
        task = FactoryBot.create(:task)
        visit task_path(task.id)

        expect(page).to have_selector "h1", text: "Show Task Page"
      end

      it '項目名が表示される' do
        task = FactoryBot.create(:task)
        visit task_path(task.id)
        
        expect(page).to have_content "Title"
        expect(page).to have_content "Content"
        expect(page).to have_content "Created_at"
      end

      it '編集画面、タスク一覧画面へのリンクが表示される' do
        task = FactoryBot.create(:task)
        visit task_path(task.id)
        
        expect(page).to have_selector "a", text: "Edit", id: "edit-task"
        expect(page).to have_selector "a", text: "Back", id: "back"
      end
    end
  end

  describe 'タスク編集画面' do
    context 'タスク編集画面に遷移した場合' do
      it '画面タイトルが表示される' do
        task = FactoryBot.create(:task)
        visit edit_task_path(task.id)

        expect(page).to have_selector "h1", text: "Edit Task Page"
      end

      it 'フォームラベルが表示される' do
        task = FactoryBot.create(:task)
        visit edit_task_path(task.id)
        
        expect(page).to have_selector "label", text: "Title"
        expect(page).to have_selector "label", text: "Content"
      end

      it '更新ボタンが表示される' do
        task = FactoryBot.create(:task)
        visit edit_task_path(task.id)

        expect(page).to have_button "Update Task", id: "update-task"
      end

      it '戻るリンクが表示される' do
        task = FactoryBot.create(:task)
        visit edit_task_path(task.id)
        
        expect(page).to have_selector "a", text: "Back", id: "back"
      end
    end
  end

  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        FactoryBot.create(:task)

        visit tasks_path
        expect(page).to have_content "Tasks Index Page"
        expect(page).to have_content "書類作成"
      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '登録済みのタスク一覧が表示される' do
        FactoryBot.create(:task)
        
        visit tasks_path
        expect(page).to have_content "Tasks Index Page"
        expect(page).to have_content "書類作成"
      end
    end
  end

  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it 'そのタスクの内容が表示される' do
        task = FactoryBot.create(:task)

        visit task_path(task.id)
        expect(page).to have_content "Show Task Page"
        expect(page).to have_content "企画書を作成する。"
      end
    end
  end
end