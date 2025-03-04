require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  let!(:user) {FactoryBot.create(:user)}

  shared_context "Create sample tasks" do
    let!(:resume_task) { FactoryBot.create(:resume_task, user_id: user.id) }
    let!(:linkedin_task) { FactoryBot.create(:linkedin_task, user_id: user.id) }
    let!(:research_task) { FactoryBot.create(:research_task, user_id: user.id) }
    let!(:apply_task) { FactoryBot.create(:apply_task, user_id: user.id) }
  end

  describe 'グローバルナビゲーション' do
    context '一覧画面に遷移した場合' do
      before do
        visit new_session_path
        fill_in "session[email]", with: user.email
        fill_in "session[password]", with: user.password
        click_on "create-session"
      end

      it 'グローバルナビゲーションが表示される' do
        visit tasks_path
        expect(page).to have_content I18n.t("defaults.navigations.tasks")
        expect(page).to have_content I18n.t("defaults.navigations.new_task")
      end
    end
  end

  describe '画面遷移' do
    context 'root' do
      before do
        visit new_session_path
        fill_in "session[email]", with: user.email
        fill_in "session[password]", with: user.password
        click_on "create-session"
      end

      it '一覧画面が表示される' do
        visit root_path
        expect(page).to have_selector "h1", text: I18n.t("tasks.index.title")
      end
    end

    context 'グローバルナビゲーション' do
      before do
        visit new_session_path
        fill_in "session[email]", with: user.email
        fill_in "session[password]", with: user.password
        click_on "create-session"
      end

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
      before do
        visit new_session_path
        fill_in "session[email]", with: user.email
        fill_in "session[password]", with: user.password
        click_on "create-session"
      end

      it '"Show"をクリックすると詳細画面が表示される' do
        task = FactoryBot.create(:task, user_id: user.id)
        visit tasks_path
        click_on I18n.t("helpers.show")
        expect(current_path).to eq task_path(task.id)
        expect(page).to have_selector "h1", text: I18n.t("tasks.show.title")
      end

      it '"Edit"をクリックすると編集画面が表示される' do
        task = FactoryBot.create(:task, user_id: user.id)
        visit tasks_path
        click_on I18n.t("helpers.edit")
        expect(current_path).to eq edit_task_path(task.id)
        expect(page).to have_selector "h1", text: I18n.t("tasks.edit.title")
      end

      it '"Destroy"をクリックすると一覧画面が表示される' do
        task = FactoryBot.create(:task, user_id: user.id)
        visit tasks_path
        page.accept_confirm(I18n.t("helpers.confirm")) do
          click_on I18n.t("helpers.destroy")
        end

        expect(page).to have_content I18n.t("tasks.index.title")
      end
    end

    context '詳細画面' do
      before do
        visit new_session_path
        fill_in "session[email]", with: user.email
        fill_in "session[password]", with: user.password
        click_on "create-session"
      end

      it '"Edit"をクリックすると編集画面が表示される' do
        task = FactoryBot.create(:task, user_id: user.id)
        visit task_path(task.id)
        click_on "edit-task"

        expect(current_path).to eq edit_task_path(task.id)
        expect(page).to have_selector "h1", text: I18n.t("tasks.edit.title")
      end

      it '"Back"をクリックすると一覧画面が表示される' do
        task = FactoryBot.create(:task, user_id: user.id)
        visit task_path(task.id)
        click_on I18n.t("helpers.back")

        expect(current_path).to eq tasks_path
        expect(page).to have_selector "h1", text: I18n.t("tasks.index.title")
      end
    end

    context '編集画面' do
      context '"Update Task"' do
        before do
          visit new_session_path
          fill_in "session[email]", with: user.email
          fill_in "session[password]", with: user.password
          click_on "create-session"
        end
  
        it '成功すると詳細画面が表示される' do
          task = FactoryBot.create(:task, user_id: user.id)
          visit edit_task_path(task.id)
          fill_in "task[title]", with: "Modified title"
          click_on "update-task"

          expect(page).to have_selector "h1", text: I18n.t("tasks.show.title")
        end

        it '失敗すると編集画面が表示される' do
          task = FactoryBot.create(:task, user_id: user.id)
          visit edit_task_path(task.id)
          fill_in "task[title]", with: ""
          click_on "update-task"

          expect(page).to have_selector "h1", text: I18n.t("tasks.edit.title")
        end
        
        it '"Back"を押すと一覧画面が表示される' do
          puts user.email
          puts user.id
  
          task = FactoryBot.create(:task, user_id: user.id)
          visit edit_task_path(task.id)
          click_on I18n.t("helpers.back")
  
          expect(current_path).to eq tasks_path
          expect(page).to have_selector "h1", text: I18n.t("tasks.index.title")
        end
      end
    end

    context '登録画面' do
      before do
        visit new_session_path
        fill_in "session[email]", with: user.email
        fill_in "session[password]", with: user.password
        click_on "create-session"
      end

      context '"Create Task"' do
        it '登録に成功した場合一覧画面が表示される' do
          visit new_task_path
          fill_in "task[title]", with: "Buy a milk"
          fill_in "task[content]", with: "Buy a milk at a supermarket"
          fill_in "task[deadline_on]", with: "20251231\t" # "2025-12-31"
          select I18n.t("enums.task.priority.medium"), from: "task[priority]"
          select I18n.t("enums.task.status.in_progress"), from: "task[status]"
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
      before do
        visit new_session_path
        fill_in "session[email]", with: user.email
        fill_in "session[password]", with: user.password
        click_on "create-session"
      end

      it '画面タイトルが表示される' do
        visit tasks_path
        expect(page).to have_selector "h1", text: I18n.t("tasks.index.title")
      end

      it 'テーブルヘッダーが表示される' do
        visit tasks_path
        expect(page).to have_selector "th", text: I18n.t("activerecord.attributes.task.title")
        expect(page).to have_selector "th", text: I18n.t("activerecord.attributes.task.content")
        expect(page).to have_selector "th", text: I18n.t("activerecord.attributes.common.created_at")
        expect(page).to have_selector "th", text: I18n.t("activerecord.attributes.task.deadline_on")
        expect(page).to have_selector "th", text: I18n.t("activerecord.attributes.task.priority")
        expect(page).to have_selector "th", text: I18n.t("activerecord.attributes.task.status")
      end

      it '属性とShow/Edit/Destroyのリンクが表示される' do
        task = FactoryBot.create(:task, user_id: user.id)

        visit tasks_path
        expect(page).to have_selector "td", text: task.title, class: "task-title"
        expect(page).to have_selector "td", text: task.content, class: "task-content"
        expect(page).to have_selector "td", text: I18n.l(task.created_at, format: :long), class: "task-created-at"
        expect(page).to have_selector "td", text: task.deadline_on, class: "task-deadline-on"
        expect(page).to have_selector "td", text: I18n.t("enums.task.priority.#{task.priority}"), class: "task-priority"
        expect(page).to have_selector "td", text: I18n.t("enums.task.status.#{task.status}"), class: "task-status"
        expect(page).to have_selector "a", text: I18n.t("helpers.show"), class: "show-task"
        expect(page).to have_selector "a", text: I18n.t("helpers.edit"), class: "edit-task"
        expect(page).to have_selector "a", text: I18n.t("helpers.destroy"), class: "destroy-task"
      end
    end
  end

  describe 'タスク登録画面' do
    context 'タスク登録画面に遷移した場合' do
      before do
        visit new_session_path
        fill_in "session[email]", with: user.email
        fill_in "session[password]", with: user.password
        click_on "create-session"
      end

      it '画面タイトルが表示される' do
        visit new_task_path
        expect(page).to have_selector "h1", text: I18n.t("tasks.new.title")
      end

      it 'フォームラベルとフィールドが表示される' do
        visit new_task_path
        expect(page).to have_selector "label", text: I18n.t("activerecord.attributes.task.title")
        expect(page).to have_selector "label", text: I18n.t("activerecord.attributes.task.content")
        expect(page).to have_selector "label", text: I18n.t("activerecord.attributes.task.deadline_on")
        expect(page).to have_selector "label", text: I18n.t("activerecord.attributes.task.priority")
        expect(page).to have_selector "label", text: I18n.t("activerecord.attributes.task.status")
        expect(page).to have_field "task[title]"
        expect(page).to have_field "task[content]"
        expect(page).to have_field "task[deadline_on]"
        expect(page).to have_field "task[priority]"
        expect(page).to have_field "task[status]"
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
      before do
        visit new_session_path
        fill_in "session[email]", with: user.email
        fill_in "session[password]", with: user.password
        click_on "create-session"
      end

      it '画面タイトルが表示される' do
        task = FactoryBot.create(:task, user_id: user.id)
        visit task_path(task.id)

        expect(page).to have_selector "h1", text: I18n.t("tasks.show.title")
      end

      it '項目名が表示される' do
        task = FactoryBot.create(:task, user_id: user.id)
        visit task_path(task.id)
        
        expect(page).to have_content I18n.t("activerecord.attributes.task.title")
        expect(page).to have_content I18n.t("activerecord.attributes.task.content")
        expect(page).to have_content I18n.t("activerecord.attributes.common.created_at")
        expect(page).to have_content I18n.t("activerecord.attributes.task.deadline_on")
        expect(page).to have_content I18n.t("activerecord.attributes.task.priority")
        expect(page).to have_content I18n.t("activerecord.attributes.task.status")
        expect(page).to have_content task.title
        expect(page).to have_content task.content
      end

      it '編集画面、タスク一覧画面へのリンクが表示される' do
        task = FactoryBot.create(:task, user_id: user.id)
        visit task_path(task.id)
        
        expect(page).to have_selector "a", text: I18n.t("helpers.edit"), id: "edit-task"
        expect(page).to have_selector "a", text: I18n.t("helpers.back"), id: "back"
      end
    end
  end

  describe 'タスク編集画面' do
    context 'タスク編集画面に遷移した場合' do
      before do
        visit new_session_path
        fill_in "session[email]", with: user.email
        fill_in "session[password]", with: user.password
        click_on "create-session"
      end

      it '画面タイトルが表示される' do
        task = FactoryBot.create(:task, user_id: user.id)
        visit edit_task_path(task.id)

        expect(page).to have_selector "h1", text: I18n.t("tasks.edit.title")
      end

      it 'フォームラベルとフィールドが表示される' do
        task = FactoryBot.create(:task, user_id: user.id)
        visit edit_task_path(task.id)
        
        expect(page).to have_selector "label", text: I18n.t("activerecord.attributes.task.title")
        expect(page).to have_selector "label", text: I18n.t("activerecord.attributes.task.content")
        expect(page).to have_selector "label", text: I18n.t("activerecord.attributes.task.deadline_on")
        expect(page).to have_selector "label", text: I18n.t("activerecord.attributes.task.priority")
        expect(page).to have_selector "label", text: I18n.t("activerecord.attributes.task.status")
        expect(page).to have_field "task[title]", with: task.title
        expect(page).to have_field "task[content]", with: task.content
        expect(page).to have_field "task[deadline_on]", with: task.deadline_on
        expect(page).to have_field "task[priority]"
        expect(page).to have_field "task[status]"
      end

      it '更新ボタンが表示される' do
        task = FactoryBot.create(:task, user_id: user.id)
        visit edit_task_path(task.id)

        expect(page).to have_button I18n.t("helpers.submit.update", model: "Task"), id: "update-task"
      end

      it '戻るリンクが表示される' do
        task = FactoryBot.create(:task, user_id: user.id)
        visit edit_task_path(task.id)
        
        expect(page).to have_selector "a", text: I18n.t("helpers.back"), id: "back"
      end
    end
  end

  describe 'バリデーションエラーメッセージ' do
    context '登録画面' do
      context 'すべて空欄で登録しようとした場合' do
        before do
          visit new_session_path
          fill_in "session[email]", with: user.email
          fill_in "session[password]", with: user.password
          click_on "create-session"
        end
  
          it 'すべてのフィールドに対してエラーメッセージが表示される' do
          visit new_task_path
          click_on "create-task"
          expect(page).to have_content I18n.t("errors.format", attribute: I18n.t("activerecord.attributes.task.title"), message: I18n.t("errors.messages.blank"))
          expect(page).to have_content I18n.t("errors.format", attribute: I18n.t("activerecord.attributes.task.content"), message: I18n.t("errors.messages.blank"))
          expect(page).to have_content I18n.t("errors.format", attribute: I18n.t("activerecord.attributes.task.deadline_on"), message: I18n.t("errors.messages.blank"))
          expect(page).to have_content I18n.t("errors.format", attribute: I18n.t("activerecord.attributes.task.priority"), message: I18n.t("errors.messages.blank"))
          expect(page).to have_content I18n.t("errors.format", attribute: I18n.t("activerecord.attributes.task.status"), message: I18n.t("errors.messages.blank"))
        end
      end
    end

    context '編集画面' do
      context 'すべて空欄で登録しようとした場合' do
      before do
        visit new_session_path
        fill_in "session[email]", with: user.email
        fill_in "session[password]", with: user.password
        click_on "create-session"
      end

        it 'すべてのフィールドに対してエラーメッセージが表示される' do
          task = FactoryBot.create(:task, user_id: user.id)
          visit edit_task_path(task.id)
          
          fill_in "task[title]", with: ""
          fill_in "task[content]", with: ""
          fill_in "task[deadline_on]", with: ""
          select "", from: "task[priority]"
          select "", from: "task[status]"

          click_on "update-task"
          
          expect(page).to have_content I18n.t("errors.format", attribute: I18n.t("activerecord.attributes.task.title"), message: I18n.t("errors.messages.blank"))
          expect(page).to have_content I18n.t("errors.format", attribute: I18n.t("activerecord.attributes.task.content"), message: I18n.t("errors.messages.blank"))
          expect(page).to have_content I18n.t("errors.format", attribute: I18n.t("activerecord.attributes.task.deadline_on"), message: I18n.t("errors.messages.blank"))
          expect(page).to have_content I18n.t("errors.format", attribute: I18n.t("activerecord.attributes.task.priority"), message: I18n.t("errors.messages.blank"))
          expect(page).to have_content I18n.t("errors.format", attribute: I18n.t("activerecord.attributes.task.status"), message: I18n.t("errors.messages.blank"))
        end
      end
    end
  end

  describe 'フラッシュメッセージ' do
    context 'タスクの登録に成功した場合' do
      before do
        visit new_session_path
        fill_in "session[email]", with: user.email
        fill_in "session[password]", with: user.password
        click_on "create-session"
      end

      it '登録のフラッシュメッセージが表示される' do
        visit new_task_path
        fill_in "task[title]", with: "Buy a milk"
        fill_in "task[content]", with: "Buy a milk at a supermarket"
        fill_in "task[deadline_on]", with: "20251231\t" # "2025-12-31"
        select I18n.t("enums.task.priority.medium"), from: "task[priority]"
        select I18n.t("enums.task.status.in_progress"), from: "task[status]"
        click_on I18n.t("helpers.submit.create", model: "Task")

        expect(page).to have_text I18n.t("tasks.create.created")
      end
    end

    context 'タスクの更新に成功した場合' do
      before do
        visit new_session_path
        fill_in "session[email]", with: user.email
        fill_in "session[password]", with: user.password
        click_on "create-session"
      end

      it '更新のフラッシュメッセージが表示される' do
        task = FactoryBot.create(:task, user_id: user.id)
        visit edit_task_path(task.id)
        fill_in "task[title]", with: "modified title"
        click_on I18n.t("helpers.submit.update", model: "Task")

        expect(page).to have_text I18n.t("tasks.update.updated")
      end
    end

    context 'タスクを削除した場合' do
      before do
        visit new_session_path
        fill_in "session[email]", with: user.email
        fill_in "session[password]", with: user.password
        click_on "create-session"
      end

      it '削除のフラッシュメッセージが表示される' do
        task = FactoryBot.create(:task, user_id: user.id)
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
      before do
        visit new_session_path
        fill_in "session[email]", with: user.email
        fill_in "session[password]", with: user.password
        click_on "create-session"
      end

      it '登録したタスクが表示される' do
        FactoryBot.create(:task, user_id: user.id)

        visit tasks_path
        expect(page).to have_content I18n.t("tasks.index.title")
        expect(page).to have_content "書類作成"
      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      before do
        visit new_session_path
        fill_in "session[email]", with: user.email
        fill_in "session[password]", with: user.password
        click_on "create-session"
      end

      let!(:first_task) { FactoryBot.create(:task, title: 'first_task', created_at: Time.zone.now, user_id: user.id) }
      let!(:second_task) { FactoryBot.create(:task, title: 'second_task', created_at: 1.day.from_now, user_id: user.id) }
      let!(:third_task) { FactoryBot.create(:task, title: 'third_task', created_at: 1.day.ago, user_id: user.id) }

      before do
        visit tasks_path
      end

      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        within "#tasks-table" do
          task_titles = all(".task-title").map(&:text)
          expect(task_titles).to eq %w(second_task first_task third_task)
        end
      end

      context '新たにタスクを作成した場合' do
        it '新しいタスクが一番上に表示される' do
          new_task = FactoryBot.create(:task, title: "forth_task", created_at: 2.day.from_now, user_id: user.id)
          
          visit tasks_path
          within "#tasks-table" do
            task_titles = all(".task-title").map(&:text)
            expect(task_titles).to eq %w(forth_task second_task first_task third_task)
          end
        end
      end

      context 'タスクの作成日時の表示' do
        it '日時のフォーマットが適用されている' do
          fifth_task = FactoryBot.create(:task, title: "fifth_task", created_at: 10.days.from_now, user_id: user.id)
          visit tasks_path
          task_created_at = all(".task-created-at").map(&:text).first
          expect(task_created_at).to eq I18n.l(fifth_task.created_at, format: :long)
        end
      end

      context 'ページネーション' do
        it '1ページに10件のタスクが表示される' do
          50.times do |n|
            FactoryBot.create(:task, title: "Task #{n}", user_id: user.id)
          end

          visit tasks_path
          task_count = all("#tasks-table tbody tr").length
          expect(task_count).to eq 10
        end

        it 'ページネーションのコントローラが表示される' do
          50.times do |n|
            FactoryBot.create(:task, title: "Task #{n}", user_id: user.id)
          end

          visit tasks_path
          expect(page).to have_selector "span", class: "page"
        end
      end
    end

    describe 'ソート機能' do
      context 'パラメータなしの場合' do
        before do
          visit new_session_path
          fill_in "session[email]", with: user.email
          fill_in "session[password]", with: user.password
          click_on "create-session"
        end

        let!(:first_task) { FactoryBot.create(:task, title: 'first_task', created_at: Time.zone.now, user_id: user.id) }
        let!(:second_task) { FactoryBot.create(:task, title: 'second_task', created_at: 1.day.from_now, user_id: user.id) }
        let!(:third_task) { FactoryBot.create(:task, title: 'third_task', created_at: 1.day.ago, user_id: user.id) }

        it '作成日の新しい順に表示される' do
          visit tasks_path
          within "#tasks-table" do
            task_titles = all(".task-title").map(&:text)
            expect(task_titles).to eq %w(second_task first_task third_task)
          end
        end
      end

      context '「終了期限」というリンクをクリックした場合' do
        before do
          visit new_session_path
          fill_in "session[email]", with: user.email
          fill_in "session[password]", with: user.password
          click_on "create-session"
        end

        let!(:first_task) { FactoryBot.create(:task, title: 'first_task', deadline_on: Time.zone.now, user_id: user.id) }
        let!(:second_task) { FactoryBot.create(:task, title: 'second_task', deadline_on: 1.day.from_now, user_id: user.id) }
        let!(:third_task) { FactoryBot.create(:task, title: 'third_task', deadline_on: 1.day.ago, user_id: user.id) }

        it '終了期限昇順に並び替えられたタスク一覧が表示される' do
          visit tasks_path
          click_on "終了期限"
          sleep 0.2
          expect(page).to have_current_path "#{tasks_path}?sort_deadline_on=true"
          within "#tasks-table" do
            task_titles = all(".task-title").map(&:text)
            expect(task_titles).to eq %w(third_task first_task second_task)
          end
        end
      end

      context '「優先度」というリンクをクリックした場合' do
        before do
          visit new_session_path
          fill_in "session[email]", with: user.email
          fill_in "session[password]", with: user.password
          click_on "create-session"
        end

        let!(:first_task) { FactoryBot.create(:task, title: 'first_task', priority: 0, user_id: user.id) } # low
        let!(:second_task) { FactoryBot.create(:task, title: 'second_task', priority: 1, user_id: user.id) } # medium
        let!(:third_task) { FactoryBot.create(:task, title: 'third_task', priority: 2, user_id: user.id) } # high

        it '優先度の高い順に並び替えられたタスク一覧が表示される' do
          visit tasks_path
          click_on "優先度"
          sleep 0.2
          expect(page).to have_current_path "#{tasks_path}?sort_priority=true"
          within "#tasks-table" do
            task_titles = all(".task-title").map(&:text)
            expect(task_titles).to eq %w(third_task second_task first_task)
          end
        end
      end
    end
  
    describe '検索機能' do
      context 'タイトルであいまい検索をした場合' do
        before do
          visit new_session_path
          fill_in "session[email]", with: user.email
          fill_in "session[password]", with: user.password
          click_on "create-session"
        end

        include_context "Create sample tasks"

        it "検索ワードを含むタスクのみ表示される" do
          visit tasks_path
          fill_in "search[title]", with: "LinkedIn"
          click_on "search_task"
          sleep 0.2
          within "#tasks-table" do
            task_titles = all(".task-title").map(&:text)
            expect(task_titles).to include(linkedin_task.title)
            expect(task_titles).not_to include(resume_task.title, research_task.title, apply_task.title)
            expect(task_titles.length).to eq 1
          end
        end
      end

      context 'ステータスで検索した場合' do
        before do
          visit new_session_path
          fill_in "session[email]", with: user.email
          fill_in "session[password]", with: user.password
          click_on "create-session"
        end

        include_context "Create sample tasks"

        it "検索したステータスに一致するタスクのみ表示される" do
          visit tasks_path
          select I18n.t("enums.task.status.not_started"), from: "search[status]"
          click_on "search_task"
          sleep 0.2
          within "#tasks-table" do
            task_titles = all(".task-title").map(&:text)
            expect(task_titles).to include(resume_task.title)
            expect(task_titles).not_to include(linkedin_task.title, research_task.title, apply_task.title)
            expect(task_titles.length).to eq 1
          end
        end
      end

      context 'タイトルとステータスで検索した場合' do
        before do
          visit new_session_path
          fill_in "session[email]", with: user.email
          fill_in "session[password]", with: user.password
          click_on "create-session"
        end

        include_context "Create sample tasks"

        it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
          visit tasks_path
          fill_in "search[title]", with: "companies"
          select I18n.t("enums.task.status.completed"), from: "search[status]"
          click_on "search_task"
          sleep 0.2
          within "#tasks-table" do
            task_titles = all(".task-title").map(&:text)
            expect(task_titles).to include(research_task.title)
            expect(task_titles).not_to include(resume_task.title, linkedin_task.title, apply_task.title)
            expect(task_titles.length).to eq 1
          end
        end
      end

      context 'ラベルで検索をした場合' do
        before do
          visit new_session_path
          fill_in "session[email]", with: user.email
          fill_in "session[password]", with: user.password
          click_on "create-session"
        end

        it "そのラベルの付いたタスクがすべて表示される" do
          # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
          label = FactoryBot.create(:label, user_id: user.id)
          task1 = FactoryBot.create(:resume_task, user_id: user.id)
          task2 = FactoryBot.create(:linkedin_task, user_id: user.id)

          task1.labels << label

          visit tasks_path
          select label.name, from: "search[label]"
          click_on "search_task"

          expect(page).to have_selector "td", text: task1.title
          expect(page).not_to have_selector "td", text: task2.title
        end
      end
    end 
  end

  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      before do
        visit new_session_path
        fill_in "session[email]", with: user.email
        fill_in "session[password]", with: user.password
        click_on "create-session"
      end

      it 'そのタスクの内容が表示される' do
        task = FactoryBot.create(:task, user_id: user.id)

        visit task_path(task.id)
        expect(page).to have_content I18n.t("tasks.show.title")
        expect(page).to have_content "企画書を作成する。"
      end
    end
  end
end