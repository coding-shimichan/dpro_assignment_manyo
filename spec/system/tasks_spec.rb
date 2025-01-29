require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe 'グローバルナビゲーション' do
    context '一覧画面に遷移した場合' do
      it 'グローバルナビゲーションが表示される' do
        visit tasks_path
        expect(page).to have_content I18n.t("defaults.navigations.tasks")
        expect(page).to have_content I18n.t("defaults.navigations.new_task")
      end
    end
  end

  describe '画面遷移' do
    context 'root' do
      it '一覧画面が表示される' do
        visit root_path
        expect(page).to have_selector "h1", text: I18n.t("tasks.index.title")
      end
    end

    context 'グローバルナビゲーション' do
      it '"Tasks Index"をクリックすると一覧画面が表示される' do
        visit new_task_path
        click_on I18n.t("defaults.navigations.tasks")
        expect(current_path).to eq tasks_path
        expect(page).to have_selector "h1", text: I18n.t("tasks.index.title")
      end

      it '"New Task"をクリックすると登録画面が表示される' do
        visit tasks_path
        click_on I18n.t("defaults.navigations.new_task")
        expect(current_path).to eq new_task_path
        expect(page).to have_selector "h1", text: I18n.t("tasks.new.title")
      end
    end
  
    context '一覧画面' do
      it '"Show"をクリックすると詳細画面が表示される' do
        task = FactoryBot.create(:task)
        visit tasks_path
        click_on I18n.t("helpers.show")
        expect(current_path).to eq task_path(task.id)
        expect(page).to have_selector "h1", text: I18n.t("tasks.show.title")
      end

      it '"Edit"をクリックすると編集画面が表示される' do
        task = FactoryBot.create(:task)
        visit tasks_path
        click_on I18n.t("helpers.edit")
        expect(current_path).to eq edit_task_path(task.id)
        expect(page).to have_selector "h1", text: I18n.t("tasks.edit.title")
      end

      it '"Destroy"をクリックすると一覧画面が表示される' do
        task = FactoryBot.create(:task)
        visit tasks_path
        page.accept_confirm(I18n.t("helpers.confirm")) do
          click_on I18n.t("helpers.destroy")
        end

        expect(page).to have_content I18n.t("tasks.index.title")
      end
    end

    context '詳細画面' do
      it '"Edit"をクリックすると編集画面が表示される' do
        task = FactoryBot.create(:task)
        visit task_path(task.id)
        click_on "edit-task"

        expect(current_path).to eq edit_task_path(task.id)
        expect(page).to have_selector "h1", text: I18n.t("tasks.edit.title")
      end

      it '"Back"をクリックすると一覧画面が表示される' do
        task = FactoryBot.create(:task)
        visit task_path(task.id)
        click_on I18n.t("helpers.back")

        expect(current_path).to eq tasks_path
        expect(page).to have_selector "h1", text: I18n.t("tasks.index.title")
      end
    end

    context '編集画面' do
      context '"Update Task"' do
        it '成功すると詳細画面が表示される' do
          task = FactoryBot.create(:task)
          visit edit_task_path(task.id)
          fill_in "task[title]", with: "Modified title"
          click_on "update-task"

          expect(page).to have_selector "h1", text: I18n.t("tasks.show.title")
        end

        it '失敗すると編集画面が表示される' do
          task = FactoryBot.create(:task)
          visit edit_task_path(task.id)
          fill_in "task[title]", with: ""
          click_on "update-task"

          expect(page).to have_selector "h1", text: I18n.t("tasks.edit.title")
        end
      end

      it '"Back"を押すと一覧画面が表示される' do
        task = FactoryBot.create(:task)
        visit edit_task_path(task.id)
        click_on I18n.t("helpers.back")

        expect(current_path).to eq tasks_path
        expect(page).to have_selector "h1", text: I18n.t("tasks.index.title")
      end
    end

    context '登録画面' do
      context '"Create Task"' do
        it '登録に成功した場合一覧画面が表示される' do
          visit new_task_path
          fill_in "task[title]", with: "Buy a milk"
          fill_in "task[content]", with: "Buy a milk at a supermarket"
          click_on "create-task"

          expect(page).to have_selector "h1", text: I18n.t("tasks.index.title")
        end

        it '登録に失敗した場合編集画面が表示される' do
          visit new_task_path
          click_on "create-task"

          expect(page).to have_selector "h1", text: I18n.t("tasks.new.title")
        end
      end
    end
  end

  describe 'タスク一覧画面' do
    context '一覧画面に遷移した場合' do
      it '画面タイトルが表示される' do
        visit tasks_path
        expect(page).to have_selector "h1", text: I18n.t("tasks.index.title")
      end

      it 'テーブルヘッダーが表示される' do
        visit tasks_path
        expect(page).to have_selector "th", text: I18n.t("activerecord.attributes.task.title")
        expect(page).to have_selector "th", text: I18n.t("activerecord.attributes.task.content")
        expect(page).to have_selector "th", text: I18n.t("activerecord.attributes.common.created_at")
      end

      it 'Show/Edit/Destroyのリンクが表示される' do
        FactoryBot.create(:task)

        visit tasks_path
        expect(page).to have_selector "a", text: I18n.t("helpers.show"), class: "show-task"
        expect(page).to have_selector "a", text: I18n.t("helpers.edit"), class: "edit-task"
        expect(page).to have_selector "a", text: I18n.t("helpers.destroy"), class: "destroy-task"
      end
    end
  end

  describe 'タスク登録画面' do
    context 'タスク登録画面に遷移した場合' do
      it '画面タイトルが表示される' do
        visit new_task_path
        expect(page).to have_selector "h1", text: I18n.t("tasks.new.title")
      end

      it 'フォームラベルが表示される' do
        visit new_task_path
        expect(page).to have_selector "label", text: I18n.t("activerecord.attributes.task.title")
        expect(page).to have_selector "label", text: I18n.t("activerecord.attributes.task.content")
      end

      it '登録ボタンが表示される' do
        visit new_task_path
        expect(page).to have_button I18n.t("helpers.submit.create", model: "Task"), id: "create-task"
      end

      it '戻るリンクが表示される' do
        visit new_task_path
        expect(page).to have_selector "a", text: I18n.t("helpers.back"), id: "back"
      end
    end
  end
  
  describe 'タスク詳細画面' do
    context 'タスク詳細画面に遷移した場合' do
      it '画面タイトルが表示される' do
        task = FactoryBot.create(:task)
        visit task_path(task.id)

        expect(page).to have_selector "h1", text: I18n.t("tasks.show.title")
      end

      it '項目名が表示される' do
        task = FactoryBot.create(:task)
        visit task_path(task.id)
        
        expect(page).to have_content I18n.t("activerecord.attributes.task.title")
        expect(page).to have_content I18n.t("activerecord.attributes.task.content")
        expect(page).to have_content I18n.t("activerecord.attributes.common.created_at")
      end

      it '編集画面、タスク一覧画面へのリンクが表示される' do
        task = FactoryBot.create(:task)
        visit task_path(task.id)
        
        expect(page).to have_selector "a", text: I18n.t("helpers.edit"), id: "edit-task"
        expect(page).to have_selector "a", text: I18n.t("helpers.back"), id: "back"
      end
    end
  end

  describe 'タスク編集画面' do
    context 'タスク編集画面に遷移した場合' do
      it '画面タイトルが表示される' do
        task = FactoryBot.create(:task)
        visit edit_task_path(task.id)

        expect(page).to have_selector "h1", text: I18n.t("tasks.edit.title")
      end

      it 'フォームラベルが表示される' do
        task = FactoryBot.create(:task)
        visit edit_task_path(task.id)
        
        expect(page).to have_selector "label", text: I18n.t("activerecord.attributes.task.title")
        expect(page).to have_selector "label", text: I18n.t("activerecord.attributes.task.content")
      end

      it '更新ボタンが表示される' do
        task = FactoryBot.create(:task)
        visit edit_task_path(task.id)

        expect(page).to have_button I18n.t("helpers.submit.update", model: "Task"), id: "update-task"
      end

      it '戻るリンクが表示される' do
        task = FactoryBot.create(:task)
        visit edit_task_path(task.id)
        
        expect(page).to have_selector "a", text: I18n.t("helpers.back"), id: "back"
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
          expect(page).to have_content I18n.t("errors.format", attribute: I18n.t("activerecord.attributes.task.title"), message: I18n.t("errors.messages.blank"))
        end
      end

      context '内容が空の場合' do
        it 'Contentのエラーメッセージが表示される' do
          visit new_task_path
          fill_in "task[title]", with: "Buy a milk"
          fill_in "task[content]", with: ""
          click_on "create-task"
          expect(page).to have_content I18n.t("errors.format", attribute: I18n.t("activerecord.attributes.task.content"), message: I18n.t("errors.messages.blank"))
        end
      end

      context 'タイトルと内容が空の場合' do
        it 'TitleとContentのエラーメッセージが表示される' do
          visit new_task_path
          fill_in "task[title]", with: ""
          fill_in "task[content]", with: ""
          click_on "create-task"
          expect(page).to have_content I18n.t("errors.format", attribute: I18n.t("activerecord.attributes.task.title"), message: I18n.t("errors.messages.blank"))
          expect(page).to have_content I18n.t("errors.format", attribute: I18n.t("activerecord.attributes.task.content"), message: I18n.t("errors.messages.blank"))
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
          expect(page).to have_content I18n.t("errors.format", attribute: I18n.t("activerecord.attributes.task.title"), message: I18n.t("errors.messages.blank"))
        end
      end

      context '内容が空の場合' do
        it 'Contentのエラーメッセージが表示される' do
          visit new_task_path
          fill_in "task[title]", with: "Buy a milk"
          fill_in "task[content]", with: ""
          click_on "create-task"
          expect(page).to have_content I18n.t("errors.format", attribute: I18n.t("activerecord.attributes.task.content"), message: I18n.t("errors.messages.blank"))
        end
      end

      context 'タイトルと内容が空の場合' do
        it 'TitleとContentのエラーメッセージが表示される' do
          visit new_task_path
          fill_in "task[title]", with: ""
          fill_in "task[content]", with: ""
          click_on "create-task"
          expect(page).to have_content I18n.t("errors.format", attribute: I18n.t("activerecord.attributes.task.title"), message: I18n.t("errors.messages.blank"))
          expect(page).to have_content I18n.t("errors.format", attribute: I18n.t("activerecord.attributes.task.content"), message: I18n.t("errors.messages.blank"))
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
        click_on I18n.t("helpers.submit.create", model: "Task")

        expect(page).to have_text I18n.t("tasks.create.created")
      end
    end

    context 'タスクの更新に成功した場合' do
      it '更新のフラッシュメッセージが表示される' do
        task = FactoryBot.create(:task)
        visit edit_task_path(task.id)
        fill_in "task[title]", with: "modified title"
        click_on I18n.t("helpers.submit.update", model: "Task")

        expect(page).to have_text I18n.t("tasks.update.updated")
      end
    end

    context 'タスクを削除した場合' do
      it '削除のフラッシュメッセージが表示される' do
        task = FactoryBot.create(:task)
        visit tasks_path

        page.accept_confirm(I18n.t("helpers.confirm")) do
          click_on I18n.t("helpers.destroy")
        end

        expect(page).to have_text I18n.t("tasks.destroy.destroyed")
      end
    end
  end

  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        FactoryBot.create(:task)

        visit tasks_path
        expect(page).to have_content I18n.t("tasks.index.title")
        expect(page).to have_content "書類作成"
      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '登録済みのタスク一覧が表示される' do
        FactoryBot.create(:task)
        
        visit tasks_path
        expect(page).to have_content I18n.t("tasks.index.title")
        expect(page).to have_content "書類作成"
      end
    end
  end

  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it 'そのタスクの内容が表示される' do
        task = FactoryBot.create(:task)

        visit task_path(task.id)
        expect(page).to have_content I18n.t("tasks.show.title")
        expect(page).to have_content "企画書を作成する。"
      end
    end
  end
end