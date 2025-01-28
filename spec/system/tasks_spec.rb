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

  describe '画面遷移' do
    context 'root' do
      it '一覧画面が表示される' do
        visit root_path
        expect(page).to have_selector "h1", text: "Tasks Index Page"
      end
    end

    context 'グローバルナビゲーション' do
      it '"Tasks Index"をクリックすると一覧画面が表示される' do
        visit new_task_path
        click_on "tasks-index"
        expect(current_path).to eq tasks_path
      end

      it '"New Task"をクリックすると登録画面が表示される' do
        visit tasks_path
        click_on "new-task"
        expect(current_path).to eq new_task_path
      end
    end
  
    context '一覧画面' do
      it '"Show"をクリックすると詳細画面が表示される' do
        task = FactoryBot.create(:task)
        visit tasks_path
        click_on "Show"
        expect(current_path).to eq task_path(task.id)
      end

      it '"Edit"をクリックすると編集画面が表示される' do
        task = FactoryBot.create(:task)
        visit tasks_path
        click_on "Edit"
        expect(current_path).to eq edit_task_path(task.id)
      end

      it '"Destroy"をクリックすると一覧画面が表示される' do
        task = FactoryBot.create(:task)
        visit tasks_path
        page.accept_confirm("Are you sure?") do
          click_on "Destroy"
        end

        expect(page).to have_content "Tasks Index Page"
      end
    end

    context '詳細画面' do
      it '"Edit"をクリックすると編集画面が表示される' do
        task = FactoryBot.create(:task)
        visit task_path(task.id)
        click_on "edit-task"

        expect(current_path).to eq edit_task_path(task.id)
      end

      it '"Back"をクリックすると一覧画面が表示される' do
        task = FactoryBot.create(:task)
        visit task_path(task.id)
        click_on "back"

        expect(current_path).to eq tasks_path
      end
    end

    context '編集画面' do
      context '"Update Task"' do
        it '成功すると詳細画面が表示される' do
          task = FactoryBot.create(:task)
          visit edit_task_path(task.id)
          fill_in "task[title]", with: "Modified title"
          click_on "update-task"

          expect(page).to have_selector "h1", text: "Show Task Page"
        end

        it '失敗すると編集画面が表示される' do
          task = FactoryBot.create(:task)
          visit edit_task_path(task.id)
          fill_in "task[title]", with: ""
          click_on "update-task"

          expect(page).to have_selector "h1", text: "Edit Task Page"
        end
      end

      it '"Back"を押すと一覧画面が表示される' do
        task = FactoryBot.create(:task)
        visit edit_task_path(task.id)
        click_on "back"

        expect(current_path).to eq tasks_path
      end
    end

    context '登録画面' do
      context '"Create Task"' do
        it '登録に成功した場合一覧画面が表示される' do
          visit new_task_path
          fill_in "task[title]", with: "Buy a milk"
          fill_in "task[content]", with: "Buy a milk at a supermarket"
          click_on "create-task"

          expect(page).to have_selector "h1", text: "Tasks Index Page"
        end

        it '登録に失敗した場合編集画面が表示される' do
          visit new_task_path
          click_on "create-task"

          expect(page).to have_selector "h1", text: "New Task Page"
        end
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

  describe 'バリデーションエラーメッセージ' do
    context '登録画面' do
      context 'タイトルが空の場合' do
        it 'Titleのエラーメッセージが表示される' do
          visit new_task_path
          fill_in "task[title]", with: ""
          fill_in "task[content]", with: "Buy a milk at supermarket"
          click_on "create-task"
          expect(page).to have_content "Title can't be blank"
        end
      end

      context '内容が空の場合' do
        it 'Contentのエラーメッセージが表示される' do
          visit new_task_path
          fill_in "task[title]", with: "Buy a milk"
          fill_in "task[content]", with: ""
          click_on "create-task"
          expect(page).to have_content "Content can't be blank"
        end
      end

      context 'タイトルと内容が空の場合' do
        it 'TitleとContentのエラーメッセージが表示される' do
          visit new_task_path
          fill_in "task[title]", with: ""
          fill_in "task[content]", with: ""
          click_on "create-task"
          expect(page).to have_content "Title can't be blank"
          expect(page).to have_content "Content can't be blank"
        end
      end
    end

    context '編集画面' do
      context 'タイトルが空の場合' do
        it 'Titleのエラーメッセージが表示される' do
          visit new_task_path
          fill_in "task[title]", with: ""
          fill_in "task[content]", with: "Buy a milk at supermarket"
          click_on "create-task"
          expect(page).to have_content "Title can't be blank"
        end
      end

      context '内容が空の場合' do
        it 'Contentのエラーメッセージが表示される' do
          visit new_task_path
          fill_in "task[title]", with: "Buy a milk"
          fill_in "task[content]", with: ""
          click_on "create-task"
          expect(page).to have_content "Content can't be blank"
        end
      end

      context 'タイトルと内容が空の場合' do
        it 'TitleとContentのエラーメッセージが表示される' do
          visit new_task_path
          fill_in "task[title]", with: ""
          fill_in "task[content]", with: ""
          click_on "create-task"
          expect(page).to have_content "Title can't be blank"
          expect(page).to have_content "Content can't be blank"
        end
      end
    end
  end

  describe 'フラッシュメッセージ' do
    context 'タスクの登録に成功した場合' do
      it '登録のフラッシュメッセージが表示される' do
        visit new_task_path
        fill_in "task[title]", with: "Buy a milk"
        fill_in "task[content]", with: "Buy a milk at a supermarket"
        click_on "Create Task"

        expect(page).to have_text "Task was successfully created."
      end
    end

    context 'タスクの更新に成功した場合' do
      it '更新のフラッシュメッセージが表示される' do
        task = FactoryBot.create(:task)
        visit edit_task_path(task.id)
        fill_in "task[title]", with: "modified title"
        click_on "Update Task"

        expect(page).to have_text "Task was successfully updated."
      end
    end

    context 'タスクを削除した場合' do
      it '削除のフラッシュメッセージが表示される' do
        task = FactoryBot.create(:task)
        visit tasks_path

        page.accept_confirm("Are you sure?") do
          click_on "Destroy"
        end

        expect(page).to have_text "Task was successfully destroyed."
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