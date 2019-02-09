require 'selenium-webdriver'

driver = Selenium::WebDriver.for :chrome
driver.navigate.to "https://jobcan.ne.jp/"
driver.quit

# driver.navigate.to "http://google.com"
# element = driver.find_element(name: 'q')
# element.send_keys "Hello WebDriver!"
# element.submit
#
# puts driver.title
#
# driver.quit
