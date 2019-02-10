require 'selenium-webdriver'
require 'date'

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
driver = Selenium::WebDriver.for :chrome, options: options
wait = Selenium::WebDriver::Wait.new(timeout: 10)

driver.navigate.to "https://id.jobcan.jp/users/sign_in"
mail_adress = ENV['MYJOBCAN_MAIL_ADDRESS']
login_password = ENV['MYJOBCAN_PASSWORD']
driver.find_element(:id, "user_email").send_keys(mail_adress)
driver.find_element(:id, "user_password").send_keys(login_password)
driver.find_element(:xpath, "//*[@id='new_user']/input[3]").click

p "Login successfully.."

driver.find_element(:xpath, "//*[@id='jbc-app-links']/ul/li[2]").click

p "Open new window for attendance.."

wait.until {
  driver.switch_to.window(driver.window_handles[1])
  driver.find_element(:xpath, "//*[@id='header']/div[2]/div/ul/li[3]").displayed?
}

driver.find_element(:xpath, "//*[@id='header']/div[2]/div/ul/li[3]").click
driver.find_element(:xpath, "//*[@id='menu_man_hour_manage']/table/tbody/tr[1]/td/a").click

p "Moved Man-hour management screen .."

driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
driver.find_elements(:class, "today-record")[0].find_elements(:tag_name, "td")[3].find_elements(:class, "btn")[0].click

wait.until {
  driver.find_element(:id, "edit-menu-contents").displayed?
}

# 以下、繰り返されるエリア
finished_sign = 'n'
@index = 0
until finished_sign != 'n' do
  # プロジェクトの入力
  driver.find_elements(:class, "btn-default")[0].click
  select_project = Selenium::WebDriver::Support::Select.new(driver.find_elements(:name, 'projects[]')[@index])
  select_project.options.each do |option|
    p option.text + " => " + option.attribute("value")
  end
  p '+++++++++++++++++++++++++'
  p 'What is your projects num1ber?'
  p '+++++++++++++++++++++++++'
  input_project = gets.chomp
  Selenium::WebDriver::Support::Select.new(driver.find_elements(:name, 'projects[]')[@index]).select_by(:value, input_project)
  
  # タスクの入力
  select_task = Selenium::WebDriver::Support::Select.new(driver.find_elements(:name, 'tasks[]')[@index])
  select_task.options.each do |option|
    p option.text + " => " + option.attribute("value")
  end
  p '+++++++++++++++++++++++++'
  p 'What is your task number?'
  p '+++++++++++++++++++++++++'
  input_task = gets.chomp
  Selenium::WebDriver::Support::Select.new(driver.find_elements(:name, 'tasks[]')[@index]).select_by(:value, input_task)
  
  # 工数の入力
  p '+++++++++++++++++++++++++'
  p 'What is your time(For example, you input 1hour => 01:00)?'
  p '+++++++++++++++++++++++++'
  input_time = gets.chomp
  driver.find_elements(:class, "man-hour-input-time")[@index].send_keys(input_time)
  
  p "Finshed inputs? y/n"
  finished_sign = gets.chomp
  @index += 1
  # on.changeを発火させるために、適当な場所をクリックし、有効にする
  driver.find_element(:xpath, "//*[@id='edit-menu-contents']/table/tbody/tr[3]/td[2]/select").click
end

driver.find_element(:id, "save").location_once_scrolled_into_view
driver.find_element(:id, "save").submit

wait.until {
  driver.execute_script("return document.readyState;") === "complete"
}

driver.quit

p "Save inputs and completed"
