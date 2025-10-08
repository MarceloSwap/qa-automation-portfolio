*** Settings ***
Documentation       Online

#Para ter acesso aos recursos da lib Browser
Resource    ../resources/base.resource

*** Test Cases ***
CT000 Webapp deve estar online
    [Tags]    online
    Start Session
    Get Text                    css=.home-container h1      equal       Welcome to Cinema App
