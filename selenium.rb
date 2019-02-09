require 'selenium-webdriver'

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
options.add_argument("--user-data-dir=" + ENV['YOUR_PROFILE_PATH'])
driver = Selenium::WebDriver.for :chrome, options: options
wait = Selenium::WebDriver::Wait.new(timeout: 10)

# inputで数を受けられるようにしたい。決まった数を解釈して一気に入力したい

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

driver.save_screenshot "aaa.png"
p "take screenshot"

driver.manage.delete_all_cookies

driver.quit


# driver.getSessionId().then(function (session) {
#   console.log(session)
# })

# driver.manage.add_cookie(name: 'key', value: 'value')
#
# driver.manage.all_cookies.each { |cookie|
#   puts "#{cookie[:name]} => #{cookie[:value]}"
# }
