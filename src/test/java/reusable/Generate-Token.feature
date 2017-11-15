Feature: Generate Token to be used for Authenticating to all Service Requests

  Background:
    * def Environment = 'ver'
    * def Channel = '02'
    * def JavaMethods = Java.type('reusable.ResuableMethods')
    * url 'https://location.' + Environment + Channel + '.geicenter.com'
    
  Scenario: Generate Token, Setup HTTPS Proxy, Drink Tequila

    * assert JavaMethods.geProxyConfig() == true

    Given path 'uaa', 'oauth', 'token'
    And form field grant_type = 'client_credentials'
    And form field response_type = 'token'
    And form field client_id = 'apm_sr_refresh_client'
    And form field client_secret = 'apmsrrefreshclientsecret'
    When method post
    Then status 200

    * def token = $.access_token
    * assert token != ''




