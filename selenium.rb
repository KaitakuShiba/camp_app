require 'selenium-webdriver'
require 'date'

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
# options.add_argument("--user-data-dir=" + ENV['YOUR_PROFILE_PATH'])
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

p "Entering parameters .."

driver.find_elements(:class, "btn-default")[0].click

select_project = Selenium::WebDriver::Support::Select.new(driver.find_elements(:name, 'projects[]')[0])
select_project.options.each do |option|
  p option.text
end
p '+++++++++++++++++++++++++'
p 'What is your projects?'
p '+++++++++++++++++++++++++'
# gets
select_project.select_by(:text, '共通')

select_task = Selenium::WebDriver::Support::Select.new(driver.find_elements(:name, 'tasks[]')[0])
select_task.options.each do |option|
  p option.text
end
p '+++++++++++++++++++++++++'
p 'What is your task?'
p '+++++++++++++++++++++++++'
# gets
select_task.select_by(:text, '保守・機能維持(04)  D0040007')

# driver.find_elements(:name, "minutes[]")[0].clear
p '+++++++++++++++++++++++++'
p 'What is your time?'
p '+++++++++++++++++++++++++'
driver.find_elements(:name, "minutes[]")[0].text === ""
driver.find_elements(:name, "minutes[]")[0].text === '00:10'
# gets

driver.find_element(:id, "save").location_once_scrolled_into_view
driver.find_element(:id, "save").submit
wait.until {
  driver.execute_script("return document.readyState;") === "complete"
}

driver.save_screenshot "result.png"

# driver.manage.delete_all_cookies

driver.quit

p "Save inputs and completed"
